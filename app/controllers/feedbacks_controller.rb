class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new(level: "conversation", uuid: params[:uuid], version: ENV["CONVERSATION_FEEDBACK_VERSION"])
    @groups = Feedback.conversation_questions['groups']
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.response = params["answers"]
  
    if @feedback.save
      if @feedback.level == "conversation"
        redirect_to complete_path(uuid: @feedback.uuid)
      else
        redirect_to new_chat_url(uuid: @feedback.uuid), notice: "Thanks for your feedback."
      end
  
      send_feedback_to_api(@feedback)
    end
  end

  def complete
    @uuid = params[:uuid]
  end

private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :uuid, :version, :level, response: {})
  end

  def send_feedback_to_api(feedback)
    api_url = 'http://localhost:5000/feedbacks'
    payload = { feedback: feedback }
    # binding.pry
    conn = Faraday.new
    response = conn.post(api_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
  end
end

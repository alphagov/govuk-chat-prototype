class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new(level: "conversation", uuid: params[:uuid], version: ENV["CONVERSATION_FEEDBACK_VERSION"])
    @groups = Feedback.conversation_questions['groups']
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.response = params["answers"]

    if @feedback.save
      redirect_to complete_path(uuid: @feedback.uuid)
    end
  end

  def complete
    @uuid = params[:uuid]
  end
  
private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :uuid, :version, :level, :response)
  end
end

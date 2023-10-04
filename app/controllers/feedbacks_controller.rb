require "csv"

class FeedbacksController < ApplicationController
  def index
    respond_to do |format|
      format.csv do
        @feedbacks = Feedback.where(version: [ENV["CONVERSATION_FEEDBACK_VERSION"], ENV["MESSAGE_FEEDBACK_VERSION"]])
        response.headers["Content-Type"] = "text/csv"
        response.headers["Content-Disposition"] = "attachment; filename=feedback.csv"
      end
    end
  end

  def new
    @feedback = Feedback.new(level: "conversation", uuid: params[:uuid], version: ENV["CONVERSATION_FEEDBACK_VERSION"])
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.response = params["answers"].to_json

    if @feedback.save
      redirect_to new_chat_url(uuid: @feedback.uuid), notice: "Thanks for your feedback."
    end
  end

private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :uuid, :version, :level, :response)
  end
end

class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new(uuid: params[:uuid])
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to new_chat_url(uuid: @feedback.uuid), notice: "Thanks for your feedback."
    end
  end

private

  def feedback_params
    params.require(:feedback).permit(:uuid, :rating, :content)
  end
end

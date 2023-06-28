class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to new_chat_url(chat_id: @feedback.chat_id), notice: "Thanks for your feedback."
    end
  end

private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :rating, :content)
  end
end

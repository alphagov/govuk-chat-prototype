class AlertsController < ApplicationController
  def store
    @alert = Alert.new(alert_params)

    if @alert.save
      redirect_to new_chat_path(chat_id: @alert.chat_id), notice: "Alert submitted"
    end
  end

  private

  def alert_params
    params.permit(:chat_id)
  end
end

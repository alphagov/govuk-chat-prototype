class ChatsController < ApplicationController
  before_action :require_user!

  def index
  end

  def new
    @chat_id = params[:chat_id] || SecureRandom.uuid
    @chats = Chat.where(chat_id: @chat_id) || Chat.new(chat_id: @chat_id)
  end

  def create
    @chat = Chat.new(chat_params)

    if params[:js_enabled] == "true"
      @chat.reply = ChatApi.fetch(@chat.chat_id, @chat.prompt)
      if @chat.save
        redirect_to new_chat_path(chat_id: @chat.chat_id)
      end
    else
      current_chat_record_count = record_count(@chat.chat_id)
      BackgroundApiCallJob.perform_now(@chat.chat_id, @chat.prompt, current_chat_record_count)
      render "refresh", locals: { chat_id: @chat.chat_id, current_chat_record_count: current_chat_record_count }
    end
  end

  def refresh
    @chat_id = params[:chat_id]
    @count = params[:count]

    current_chat_record_count = record_count(@chat_id)

    if current_chat_record_count > @count.to_i
      redirect_to new_chat_path(chat_id: @chat_id)
    else
      render "refresh", locals: { chat_id: @chat_id, current_chat_record_count: current_chat_record_count }
    end
  end

private

  def chat_params
    params.require(:chat).permit(:chat_id, :prompt, :reply)
  end

  def record_count(chat_id)
    record_count = 0
    chat = Chat.where(chat_id: chat_id)
    record_count = chat.count if chat
  end
end

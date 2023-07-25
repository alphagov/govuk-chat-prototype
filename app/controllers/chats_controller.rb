class ChatsController < ApplicationController
  def index
  end

  def new
    @chat_id = params[:chat_id] || SecureRandom.uuid
    @chats = Chat.where(chat_id: @chat_id) || Chat.new(chat_id: @chat_id)
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.reply = chat_api(chat_params)

    if @chat.save
      redirect_to new_chat_path(chat_id: @chat.chat_id)
    end
  end

private

  def chat_params
    params.require(:chat).permit(:chat_id, :prompt, :reply)
  end

  def chat_api(chat_params)
    body = { chat_id: chat_params[:chat_id], user_query: chat_params[:prompt] }.to_json
    conn = Faraday.new(
      url: ENV["CHAT_API_URL"],
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
    )

    response = conn.post("/govchat", body)
    response.body
  end
end

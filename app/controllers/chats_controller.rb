require "openai"

class ChatsController < ApplicationController
  def new
    @chat_id = params[:chat_id] || SecureRandom.uuid
    @chats = Chat.where(chat_id: @chat_id) || Chat.new(chat_id: @chat_id)
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.reply = chat_api(chat_params)
    @chats = Chat.where(chat_id: @chat_id) || Chat.new(chat_id: @chat_id)

    if @chat.save
      ChatChannel.broadcast_to(
        @chat,
        render_to_string(partial: "chat", locals: {chats: @chats})
      )
      head :ok
    end
  end

private

  def chat_params
    params.require(:chat).permit(:chat_id, :prompt, :reply)
  end

  def chat_api(chat_params)
    conn = Faraday.new(
      url: ENV["CHAT_API_URL"],
      params: { chat_id: chat_params[:chat_id], prompt: chat_params[:prompt] },
      headers: { "Content-Type" => "application/json" }
    )

    response = conn.post("/")
    response.body
  end
end

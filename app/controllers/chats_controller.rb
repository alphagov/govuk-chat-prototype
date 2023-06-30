require "openai"

class ChatsController < ApplicationController
  def new
    @chat_id = params[:chat_id] || SecureRandom.uuid
    @chats = Chat.where(chat_id: @chat_id) || Chat.new(chat_id: @chat_id)
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.reply = call_openai_api(@chat.prompt)

    if @chat.save
      redirect_to root_path(chat_id: @chat.chat_id)
    end
  end

private

  def chat_params
    params.require(:chat).permit(:chat_id, :prompt, :reply)
  end

  def call_openai_api(prompt)
    response = []
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: dress_prompt(prompt)}],
        temperature: 0.7,
        stream: proc do |chunk, _bytesize|
          response << chunk.dig("choices", 0, "delta", "content")
        end
      }
    )
    response.join
  end

  def dress_prompt(prompt)
    if ENV["DRESS_OPENAI_PROMPT"] == "true"
      "You are an expert in content design and work for the UK government. You work for GOV UK. Your goals are to: - write some guidance on #{prompt}. - You must adhere to the GDS style guide for writing good content."
    else
      prompt
    end
  end
end

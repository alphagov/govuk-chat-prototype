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
    # if in the development environment, fake the API response
    if Rails.env.development?
      fake_chat_api()
    else 
      body = { chat_id: chat_params[:chat_id], user_query: chat_params[:prompt] }.to_json
      conn = Faraday.new(
        url: ENV["CHAT_API_URL"],
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      )
      conn.set_basic_auth(ENV["API_AUTH_USERNAME"], ENV["API_AUTH_PASSWORD"])

      response = conn.post("/govchat", body)
      response.body
    end
  end

  def fake_chat_api
    renderer = Redcarpet::Render::HTML.new(prettify: true)
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
    random_markdown = Faker::Markdown.sandwich(sentences: 4, repeat: 4)
    
    { 
      "answer": markdown.render(random_markdown),
      "sources": [
        "https://www.gov.uk/find-utr-number",
        "https://www.gov.uk/government/publications/national-insurance-get-your-national-insurance-number-in-writing-ca5403"
      ]
    }.to_json
  end
end

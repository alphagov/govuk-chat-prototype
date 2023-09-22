class ChatApi
  def self.fetch(chat_id, chat_prompt)
    body = { chat_id: chat_id, user_query: chat_prompt }.to_json
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

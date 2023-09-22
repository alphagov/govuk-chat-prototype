class BackgroundApiCallJob < ApplicationJob
  queue_as :default

  def perform(chat_id, prompt, current_chat_record_count)
    reply = ChatApi.fetch(chat_id, prompt)
    Chat.create(chat_id: chat_id, prompt: prompt, reply: reply)
  end
end

class BackgroundApiCallJob < ApplicationJob
  queue_as :default

  def perform(uuid, prompt, current_chat_record_count)
    reply = ChatApi.fetch(uuid, prompt)
    Chat.create(uuid: uuid, prompt: prompt, reply: reply)
  end
end

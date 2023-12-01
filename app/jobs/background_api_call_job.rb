class BackgroundApiCallJob < ApplicationJob
  queue_as :default

  def perform(uuid, prompt, _current_chat_record_count)
    reply = ChatApi.fetch(uuid, prompt)
    Chat.create(uuid:, prompt:, reply:)
  end
end

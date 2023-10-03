class RenameChatsChatIdToUuid < ActiveRecord::Migration[7.0]
  def change
    rename_column(:chats, :chat_id, :uuid)
  end
end

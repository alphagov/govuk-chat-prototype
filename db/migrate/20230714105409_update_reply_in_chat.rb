class UpdateReplyInChat < ActiveRecord::Migration[7.0]
  def change
    change_column :chats, :reply, :json
  end
end

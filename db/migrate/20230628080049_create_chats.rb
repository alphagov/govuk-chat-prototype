class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :chat_id
      t.text :prompt
      t.json :reply

      t.timestamps
    end
  end
end

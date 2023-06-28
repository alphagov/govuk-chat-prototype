class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :chat_id
      t.integer :rating
      t.text :content

      t.timestamps
    end
  end
end

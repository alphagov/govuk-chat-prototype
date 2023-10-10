class UpdateFeedback < ActiveRecord::Migration[7.0]
  def change
    remove_column(:feedbacks, :chat_id)
    remove_column(:feedbacks, :rating)
    remove_column(:feedbacks, :content)

    add_column(:feedbacks, :chat_id, :integer)
    add_column(:feedbacks, :uuid, :string)
    add_column(:feedbacks, :version, :string)
    add_column(:feedbacks, :level, :string)
    add_column(:feedbacks, :response, :json)
  end
end

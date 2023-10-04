class AddEmailSentToPasswordlessSession < ActiveRecord::Migration[7.0]
  def change
    add_column :passwordless_sessions, :email_sent, :boolean, default: false
  end
end

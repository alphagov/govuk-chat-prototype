require 'notifications/client'

class NotifyService
  attr_reader :notify_api_key
  def initialize
    @notify_api_key = ENV['NOTIFY_API_KEY']
  end

  def send_email(token, email)
    client = Notifications::Client.new(notify_api_key)
    client.send_email(
      email_address: email,
      template_id: ENV['TEMPLATE_ID'],
      personalisation: {
        govuk_chat_magic_link: "#{ENV['HOST']}#{token}"
      }
    )
    puts "Sent to: #{email}."
  end
end

class MagicLinkEmails
  #Sends batches of magic link emails
  def self.send_batch(emails)
    emails.split(" ").each do |email|
      user = User.find_by_email(email)
      session = Passwordless::Session.find_by_authenticatable_id(user.id)
      unless session.email_sent
        notify(session.token, user.email)
        record_email_sent(session)
      end
    end
  end

  def self.notify(token, user_email)
    notify = NotifyService.new
    notify.send_email(token, user_email)
  end

  def self.record_email_sent(session)
    session.email_sent = true
    session.save
  end
end

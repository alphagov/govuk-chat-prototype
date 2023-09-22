namespace :magic_link do
  task create_users: [:environment] do
    create_users
  end

  task create_auth: [:environment] do
    create_passwordless_session
  end

  task send_emails:[:environment] do
    send_emails
  end

  def create_users
    #create users using a list of email addresses
    #will need to pass these as an argument from the CLI or connect
    #to a private google sheet
    emails = %w[test@test.com]
    emails.each do |email|
      unless User.find_by_email(email)
        User.create(email: email)
      end
    end
  end

  def create_passwordless_session
    #TODO figure out how to update if already exists?
    User.all.each do |user|
      Passwordless::Session.create(authenticatable_type: "User", authenticatable_id: user.id, timeout_at: Time.now + 10.minutes, expires_at: Time.now + 10.minutes, user_agent: "na", remote_addr: "na", token: create_token)
      puts "created"
    end
  end

  def create_token
    #create token for passwordless session
    algorithm = "SHA256"
    chars = [*"A".."Z", *"0".."9"].freeze
    str = chars.sample(6).join

    key = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key("passwordless")
    OpenSSL::HMAC.hexdigest(algorithm, key, str)
  end

  def send_emails
    Passwordless::Session.all.each do |session|
      if User.find(session.authenticatable_id)
        user_email = User.find(session.authenticatable_id).email
        notify = NotifyService.new
        notify.send_email(session.token, user_email)
      end
    end
  end
end
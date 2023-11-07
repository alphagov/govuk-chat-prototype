class PopulatePasswordlessSessions
  def self.create(emails)
    emails.split(" ").each do |email|
      email = email.downcase
      user = User.find_by_email(email)
      #Help to prevent multiple passwordless sessions per user
      unless Passwordless::Session.find_by_authenticatable_id(user.id)
        self.create_passwordless_session(user)
      end
    end
  end

  def self.update(user_id)
    session = Passwordless::Session.find_by_authenticatable_id(user_id)
    session.update(token: create_token,
      timeout_at: Time.now + 2.days,
      expires_at: Time.now + 2.days,
      claimed_at: nil,
      email_sent: false
    )
    puts "Updated!"
  end

private

  def self.create_passwordless_session(user)
    Passwordless::Session.create(
          authenticatable_type: "User",
          authenticatable_id: user.id,
          user_agent: "na",
          remote_addr: "na",
          token: create_token
        )
    puts "Created session for: #{user.email}"
  end

  def self.create_token
    OpenSSL::HMAC.hexdigest(algorithm, key, str)
  end

  def self.algorithm
    "SHA256"
  end

  def self.chars
    chars = [*"A".."Z", *"0".."9"].freeze
  end

  def self.str
    chars.sample(6).join
  end

  def self.key
    ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key("passwordless")
  end
end

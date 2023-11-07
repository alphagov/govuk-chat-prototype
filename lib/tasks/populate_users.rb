class PopulateUsers
  def self.create(emails)
    emails.split(" ").each do |email|
      email = email.downcase
      #Help to prevent duplicate email addresses
      unless User.find_by_email(email)
        User.create(email: email)
        puts "Created user: #{email}"
      end
    end
  end
end

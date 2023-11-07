require_relative 'populate_users'
require_relative 'populate_passwordless_sessions'
require_relative 'magic_link_emails'
require_relative 'cloud_storage'

namespace :magic_link do
  #Create users and send them magic links
  #Args are separated with a space:
  #bundle exec rake "magic_link:batch_create_and_send_magic_links[test@test.com testtest@test.com]"
  task :batch_create_and_send_magic_links, [:filename] => [:environment] do |t, args|
    email_addresses = CloudStorage.read_file(args[:filename])
    PopulateUsers.create(email_addresses)
    PopulatePasswordlessSessions.create(email_addresses)
    MagicLinkEmails.send_batch(email_addresses)
  end

  #Individual tasks for creating users and sending emails

  #Create new users
  task :create_users, [:filename] => [:environment] do |t, args|
    puts args[:filename]
    emails = CloudStorage.read_file(args[:filename])
    PopulateUsers.create(emails)
  end

  #Create magic links for users
  #Users must have already been created using create_users
  task :create_magic_links, [:filename] => [:environment] do |t, args|
    emails = CloudStorage.read_file(args[:filename])
    PopulatePasswordlessSessions.create(emails)
  end

  #Send magic link emails
  #Sessions must have already been created using create_magic_links
  task :send_magic_link_email_batch, [:filename] => [:environment] do |t, args|
    emails = CloudStorage.read_file(args[:filename])
    MagicLinkEmails.send_batch(emails)
  end

  #Additional ways to send emails

  #Regenerate magic link and send email to existing user
  task :resend_magic_links, [:filename] => [:environment] do |t, args|
    emails = CloudStorage.read_file(args[:filename])
    emails.split(" ").each do |email|
      user = User.find_by_email(email)

      PopulatePasswordlessSessions.update(user.id)
      session = Passwordless::Session.find_by_authenticatable_id(user.id)
      MagicLinkEmails.notify_resend(session.token, user.email)
      MagicLinkEmails.record_email_sent(session)
    end
  end
end
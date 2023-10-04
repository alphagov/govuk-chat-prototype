require_relative 'populate_users'
require_relative 'populate_passwordless_sessions'
require_relative 'magic_link_emails'

namespace :magic_link do
  #Individual tasks for creating users and sending emails

  #Create new users
  task :create_users, [:emails] => [:environment] do |t, args|
    PopulateUsers.create(args.emails)
  end

  #Create magic links for users
  #Users must have already been created using create_users
  task :create_magic_links, [:emails] => [:environment] do |t, args|
    PopulatePasswordlessSessions.create(args.emails)
  end

  #Send magic link emails
  #Sessions must have already been created using create_magic_links
  task :send_magic_link_email_batch, [:emails] => [:environment] do |t, args|
    MagicLinkEmails.send_batch(args.emails)
  end

end
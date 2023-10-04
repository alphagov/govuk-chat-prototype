require_relative 'populate_users'
require_relative 'populate_passwordless_sessions'
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
end
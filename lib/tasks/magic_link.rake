require_relative 'populate_users'
namespace :magic_link do
  #Individual tasks for creating users and sending emails

  #Create new users
  task :create_users, [:emails] => [:environment] do |t, args|
    PopulateUsers.create(args.emails)
  end
end
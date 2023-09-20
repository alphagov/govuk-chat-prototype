source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

gem "rails", "7.0.5.1"

gem "bootsnap", require: false
gem "faraday"
gem "importmap-rails"
gem "jbuilder"
gem 'notifications-ruby-client'
gem "passwordless", "~> 0.12.0"
gem "pg"
gem "puma"
gem "redis"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv-rails"
  gem "letter_opener"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

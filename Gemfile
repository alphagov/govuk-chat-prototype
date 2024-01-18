source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

gem "rails", "7.0.7.1"

gem "bootsnap", require: false
gem "faraday"
gem "google-cloud-storage"
gem "importmap-rails"
gem "jbuilder"
gem "pg"
gem "puma"
gem "redis"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "byebug"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "rubocop-govuk", require: false
end

group :development do
  gem "brakeman"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webdrivers"
end

source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'

gem 'pg'
gem 'devise'
gem 'cancan'
gem 'simple_form'
gem 'haml-rails'
gem 'guise'
gem 'active_model_serializers', "~> 0.8.1"
gem 'kaminari'
gem 'cocaine'
gem 'posix-spawn'
gem 'ldaptic'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'responders'
gem 'dotenv'
gem 'paraphrase'
gem 'faker', require: false

# assets
gem 'jquery-rails'
gem 'sass-rails', "5.0.7"
gem 'uglifier', '>= 1.3.0'
gem 'bourbon'
gem 'backbone-support', git: 'https://github.com/thoughtbot/backbone-support'
gem 'js-routes'

group :development do
  gem 'capistrano', '< 3'
  gem 'capistrano-sidekiq'
  gem 'capistrano-env', git: 'https://github.com/ecbypi/capistrano-env'
  gem "listen"
  gem "web-console", "~> 2.0"
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'pry-remote'
end

group :test do
  gem "capybara"
  gem 'orderly'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'launchy'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'selenium-webdriver'
  gem "webdrivers"
end

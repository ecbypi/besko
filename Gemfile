source 'https://rubygems.org'

gem 'rails', '4.1.5'

gem 'pg'
gem 'devise'
gem 'cancan'
gem 'simple_form'
gem 'draper'
gem 'haml-rails'
gem 'guise'
gem 'active_model_serializers'
gem 'kaminari'
gem 'oj'
gem 'cocaine'
gem 'posix-spawn'
gem 'ldaptic'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'
gem 'dalli'
gem 'carmen-rails'
gem 'responders'

group :production, :staging do
  gem 'newrelic_rpm'
  gem 'honeybadger'
end

# assets
gem 'jquery-rails'
gem 'sass-rails', "~> 4.0.0"
gem 'coffee-rails', "~> 4.0.0"
gem 'uglifier', '>= 1.3.0'
gem 'bourbon'
gem 'therubyracer', require: 'v8' # for precompiling assets
gem 'backbone-support', github: 'ecbypi/backbone-support'
gem 'js-routes'

group :development do
  gem 'capistrano', '< 3'
  gem 'foreman'
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'respec'
  gem 'capistrano-sidekiq'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'jasminerice', github: 'bradphelan/jasminerice'
  gem 'fuubar'
  gem 'pry-remote'
  gem 'quiet_assets'
end

group :test do
  gem 'orderly'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'poltergeist'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'selenium-webdriver'
  gem 'codeclimate-test-reporter'
end

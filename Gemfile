source 'https://rubygems.org'

gem 'rails', '4.0.4'

gem 'mysql2'
gem 'devise'
gem 'cancan'
gem 'inherited_resources'
gem 'simple_form'
gem 'draper'
gem 'haml-rails'
gem 'squeel'
gem 'guise'
gem 'active_model_serializers'
gem 'kaminari'
gem 'oj'
gem 'cocaine'
gem 'posix-spawn'
gem 'ldaptic'
gem 'ember-rails'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'
gem 'dalli'
gem 'carmen-rails'

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
gem 'handlebars-source', '1.0.0.rc.4'

group :development do
  gem 'capistrano', '< 3'
  gem 'foreman'
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'respec'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'jasminerice', github: 'bradphelan/jasminerice'
  gem 'fuubar'
  gem 'pry-remote'
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

source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'mysql2'
gem 'devise', '2.2.5'
gem 'cancan'
gem 'inherited_resources'
gem 'simple_form'
gem 'draper'
gem 'haml'
gem 'squeel'
gem 'guise'
gem 'active_model_serializers'
gem 'kaminari'
gem 'oj'
gem 'cocaine'
gem 'posix-spawn'
gem 'ldaptic'
gem 'ember-rails', github: 'emberjs/ember-rails'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'slim'
gem 'whenever'
gem 'dalli'
gem 'strong_parameters'
gem 'carmen-rails', github: 'ecbypi/carmen-rails', branch: 'pass-form-object'

group :production, :staging do
  gem 'newrelic_rpm'
  gem 'honeybadger'
end

group :assets do
  gem 'jquery-rails'
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'bourbon'
  gem 'therubyracer', require: 'v8' # for precompiling assets
  gem 'handlebars-source', '1.0.0.rc.4'
end

group :development do
  gem 'capistrano', '< 3'
  gem 'sextant'
  gem 'foreman'
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'respec'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'jasminerice'
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
end

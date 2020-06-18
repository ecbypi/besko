ENV["RAILS_ENV"] ||= 'test'
ENV['DEVISE_EMAIL'] ||= 'besko-test@mit.edu'
ENV['HOST_FOR_EMAIL_URLS'] ||= 'besko-test.mit.edu'
ENV['LDAP_SERVER'] ||= 'ldap.foo.edu'
ENV["SHIBBOLETH_LOGIN_HANDLER"] ||= "https://testshib.org/Shibboleth.sso/Login"
ENV["SHIBBOLETH_LOGOUT_HANDLER"] ||= "https://testshib.org/Shibboleth.sso/Logout"
ENV["DESK_WORKERS_GROUP"] ||= "fakegroup"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'sidekiq/testing/inline'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require "webdrivers/chromedriver"
Webdrivers.cache_time = 0
Selenium::WebDriver::Chrome::Service.driver_path = Webdrivers::Chromedriver.update

Capybara.register_driver(:chrome_headless) do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  unless ENV.key?("DISABLE_HEADLESS")
    options.headless!
  end

  options.add_argument("--window-size=1400,1200")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.javascript_driver = :chrome_headless
  config.ignore_hidden_elements = true
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = "tmp/rspec-failures"
  config.expose_dsl_globally = false

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    reset_email
  end

  config.include EmailSpec::Matchers, type: :mailer
  config.include EmailSpec::Helpers, type: :mailer
  config.include FactoryBot::Syntax::Methods

  config.include CommandStubbing
  config.include EmailSteps

  config.include SessionSteps, type: :feature
  config.include DOMElementSteps, type: :feature
  config.include PageRenderHelper, type: :feature, js: true
end

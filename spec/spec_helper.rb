require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'
ENV['DEVISE_EMAIL'] ||= 'besko-test@mit.edu'
ENV['HOST_FOR_EMAIL_URLS'] ||= 'besko-test.mit.edu'
ENV['LDAP_SERVER'] ||= 'ldap.foo.edu'
ENV["SHIBBOLETH_LOGIN_HANDLER"] ||= "https://testshib.org/Shibboleth.sso/Login"
ENV["SHIBBOLETH_LOGOUT_HANDLER"] ||= "https://testshib.org/Shibboleth.sso/Logout"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'sidekiq/testing/inline'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :poltergeist
Capybara.ignore_hidden_elements = true

require 'selenium/webdriver'
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.infer_spec_type_from_file_location!
  config.expose_dsl_globally = false
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Rails.cache.clear
    reset_email
  end

  config.include EmailSpec::Matchers, type: :mailer
  config.include EmailSpec::Helpers, type: :mailer
  config.include FactoryGirl::Syntax::Methods

  config.include CommandStubbing
  config.include EmailSteps

  config.include SessionSteps, type: :feature
  config.include DOMElementSteps, type: :feature
  config.include PageRenderHelper, type: :feature, js: true
end

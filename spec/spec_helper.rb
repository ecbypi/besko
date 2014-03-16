require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'

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
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['extensions.password_manager_enabled'] = false
  Capybara::Selenium::Driver.new(app, profile: profile, browser: :chrome)
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    reset_email
    Rails.cache.clear
  end

  config.include EmailSpec::Matchers, type: :mailer
  config.include EmailSpec::Helpers, type: :mailer
  config.include FactoryGirl::Syntax::Methods

  config.include LDAPSearchStubbing
  config.include EmailMacros
  config.include FactoryGirlStepHelpers

  config.include SessionSteps, type: :feature
  config.include DOMElementSteps, type: :feature
  config.include PageRenderHelper, type: :feature, js: true
end

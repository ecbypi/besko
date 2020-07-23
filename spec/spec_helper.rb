require "dotenv"
Dotenv.load! ".env.test"

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'capybara/rspec'
require "email_spec/rspec"
require 'sidekiq/testing/inline'

require "webdrivers/chromedriver"
Webdrivers.cache_time = 0
Selenium::WebDriver::Chrome::Service.driver_path = Webdrivers::Chromedriver.update

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

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
  config.server = :webrick
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
    with.library :active_record
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = "tmp/rspec-failures"
  config.expose_dsl_globally = false

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.order = 'random'
  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do |example|
    # Rails always sets this to `:puma` before each system test; we want to use `:webrick`
    # because it's simpler
    Capybara.server = :webrick

    if example.metadata[:js]
      driven_by Capybara.javascript_driver
    else
      driven_by Capybara.default_driver
    end
  end

  config.include FactoryBot::Syntax::Methods
  config.include CommandStubbing

  config.include SessionSteps, type: :system
  config.include DOMElementSteps, type: :system
end

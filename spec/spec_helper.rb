require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'
ENV['DEVISE_EMAIL'] ||= 'besko-test@mit.edu'
ENV['HOST_FOR_EMAIL_URLS'] ||= 'besko-test.mit.edu'
ENV['LDAP_SERVER'] ||= 'ldap.foo.edu'

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

  config.include LDAPSearchStubbing
  config.include EmailSteps

  config.include SessionSteps, type: :feature
  config.include DOMElementSteps, type: :feature
  config.include PageRenderHelper, type: :feature, js: true

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!

  # Setting this config option `false` removes rspec-core's monkey patching of the
  # top level methods like `describe`, `shared_examples_for` and `shared_context`
  # on `main` and `Module`. The methods are always available through the `RSpec`
  # module like `RSpec.describe` regardless of this setting.
  # For backwards compatibility this defaults to `true`.
  #
  # https://relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/global-namespace-dsl
  config.expose_dsl_globally = false
end

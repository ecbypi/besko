ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :poltergeist
Capybara.ignore_hidden_elements = true

RSpec.configure do |config|
  # Allow only desired specs to run by adding filters to spec definition
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start

    if example.metadata[:type] == :request
      stub_on_campus!
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
    reset_email
  end

  config.include EmailSpec::Matchers
  config.include EmailSpec::Helpers
  config.include FactoryGirl::Syntax::Methods

  config.include LDAPSearchStubbing
  config.include EmailMacros
  config.include FactoryGirlStepHelpers

  config.include SessionSteps, type: :request
  config.include DOMElementSteps, type: :request
  config.include PageRenderHelper, type: :request, js: true
end

# fix for using url_helpers in decorator specs
module Draper::ViewContextFilter
  alias :original_set_current_view_context :set_current_view_context

  def set_current_view_context
    controller = ApplicationController.new
    controller.request = ActionDispatch::TestRequest.new
    controller.original_set_current_view_context
  end
end

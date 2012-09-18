require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'turnip/capybara'
  require 'capybara/poltergeist'

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
    end

    config.after(:each) do
      DatabaseCleaner.clean
      reset_email
    end

    config.include EmailSpec::Matchers
    config.include EmailSpec::Helpers
    config.include FactoryGirl::Syntax::Methods

  end

  Capybara.javascript_driver = :poltergeist

  # fix for using url_helpers in decorator specs
  module Draper::ViewContextFilter
    alias :original_set_current_view_context :set_current_view_context

    def set_current_view_context
      controller = ApplicationController.new
      controller.request = ActionDispatch::TestRequest.new
      controller.original_set_current_view_context
    end
  end
end

Spork.each_run do
  FactoryGirl.reload

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Dir.glob('spec/steps/**/*steps.rb') { |f| load f, true }

  RSpec.configure do |config|
    config.include LDAPSearchStubbing
    config.include EmailMacros
    config.include DOMElementHelpers
    config.include FactoryGirlStepHelpers
  end
end

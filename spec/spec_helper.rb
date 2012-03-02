require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.

  # fix for using url_helpers in specs
  module Draper::ViewContextFilter
    alias :original_set_current_view_context :set_current_view_context

    def set_current_view_context
      controller = ApplicationController.new
      controller.request = ActionDispatch::TestRequest.new
      controller.original_set_current_view_context
    end
  end

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Allow only desired specs to run by adding filters to spec definition
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end

require 'rubygems'
require 'spork'

Spork.prefork do
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  require 'cucumber/rails'
  Capybara.default_selector = :css
  ActionController::Base.allow_rescue = false
  begin
    DatabaseCleaner.strategy = :truncation
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

end
 
Spork.each_run do
  FactoryGirl.reload
  DatabaseCleaner.clean
end

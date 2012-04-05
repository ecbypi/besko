require 'cucumber/rspec/doubles'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

World(EmailMacros)
World(LDAPSearchStubbing)
World(RoleMocking)

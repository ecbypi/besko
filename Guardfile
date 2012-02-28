group :test do
  guard 'spork', :cucumber => true, :test_unit => false, :rspec_env => { 'RAILS_ENV' => 'test' }, :cucmber_env => { 'RAILS_ENV' => 'test' }, :notifications => false do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch('Gemfile.lock')
    watch('features/support/env.rb')
  end
end

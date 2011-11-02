# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', :cucumber => true, :test_unit => false, :rspec_env => { 'RAILS_ENV' => 'test' }, :cucmber_env => { 'RAILS_ENV' => 'test' }, :notifications => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch('Gemfile.lock')
end

guard 'rspec', :version => 2, :all_on_start => false, :all_after_pass => false, :notifications => false, :cli => '--drb' do
  watch(%r{^spec/factories/.*\.rb})
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
end

guard 'cucumber', :notifications => false, :cli => '--drb', :keep_failed => false, :all_after_pass => false, :all_on_start => false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

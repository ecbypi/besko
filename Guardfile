group :test do
  guard 'spork', :test_unit => false, :rspec_env => { 'RAILS_ENV' => 'test' }, :cucumber => false, :notifications => false do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch('Gemfile.lock')
    watch('features/support/env.rb')
  end
end

group :browser do
  guard 'livereload' do
    watch(%r{app/.+\.(erb|haml)})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{(public/|app/assets).+\.(css|js|html)})
    watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
    watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
    watch(%r{config/locales/.+\.yml})
  end
end

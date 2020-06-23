ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# If `require` returns false, we have already loaded `dotenv` and loaded an env file.
if require "dotenv"
  Dotenv.load
end

require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Besko
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.time_zone = 'Eastern Time (US & Canada)'

    # Default url information
    config.action_mailer.default_url_options = {
      host: ENV['HOST_FOR_EMAIL_URLS'],
      protocol: 'https'
    }
    # SMTP settings
    config.action_mailer.smtp_settings = {
      address: 'outgoing.mit.edu',
      port: 25
    }


    config.active_job.queue_adapter = :sidekiq
  end
end

require "ext/arel"

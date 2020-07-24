require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Besko
  class Application < Rails::Application
    config.load_defaults 5.0

    config.encoding = "utf-8"
    config.time_zone = 'Eastern Time (US & Canada)'

    # Default url information
    config.action_mailer.default_url_options = {
      host: ENV['HOST_FOR_EMAIL_URLS'],
      protocol: 'https'
    }
    config.action_mailer.delivery_job = "ActionMailer::MailDeliveryJob"
    # SMTP settings
    config.action_mailer.smtp_settings = {
      address: 'outgoing.mit.edu',
      port: 25
    }

    config.active_job.queue_adapter = :sidekiq
  end
end

require "ext/arel"
require "people_api"

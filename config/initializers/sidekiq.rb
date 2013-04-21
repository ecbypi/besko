Sidekiq.configure_client do |config|
  config.redis = { namespace: "besko-#{Rails.env}" }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: "besko-#{Rails.env}" }
end

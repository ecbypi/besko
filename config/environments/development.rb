Rails.application.configure do
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false

  config.action_view.raise_on_missing_translations = true
  config.active_record.migration_error = :page_load
  config.active_support.deprecation = :raise

  config.assets.quiet = true
  config.assets.raise_runtime_errors = true

  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
end

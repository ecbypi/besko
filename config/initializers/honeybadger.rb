Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_TOKEN']
  config.environment_name = ENV['STAGE_NAME'] || Rails.env
  config.log_exception_on_send_failure = true

  config.async do |notice|
    HoneybadgerWorker.perform_async(notice.to_json)
  end
end

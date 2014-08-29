class HoneybadgerWorker
  include Sidekiq::Worker

  def perform(notice_json)
    Honeybadger.sender.send_to_honeybadger(notice_json)
  end
end

class UpdateAddressWorker
  include Sidekiq::Worker

  attr_reader :user

  def self.update_addresses
    User.pluck(:id).each { |id| perform_async(id) }
  end

  def perform(user_id)
    @user = User.find(user_id)

    if user.login? && street.present? && user.street != street
      user.update_address!(street)
    end
  end

  private

  def street
    search_result['street']
  end

  def search_result
    @search_result ||= DirectorySearch.search(user.login).first || {}
  end
end

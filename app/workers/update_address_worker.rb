class UpdateAddressWorker
  include Sidekiq::Worker

  def perform
    kerberos_principles = User.where.not(login: nil).pluck(:login, :street)

    kerberos_principles.each do |kerberos, street|
      result = DirectorySearch.search(kerberos).first || {}
      result = result['street']

      if result.present? && result != street
        User.where(login: kerberos).update_all(street: result)
      end
    end
  end
end

class DeliveriesController < InheritedResources::Base
  respond_to :html, :json
  authorize_resource

  def new
    ids = (cookies['recipients'] || '').split(',')
    @recipients = ActiveModel::ArraySerializer.new(User.find(ids))
  end

  def create
    create!(notice: 'Notifications Sent', error: 'Unable to log delivery.') do
      PackageMailer.send_receipts(resource)
      new_delivery_path
    end
  end

  private

  def create_resource(object)
    object.user = current_user
    object.save
  end

  def collection
    @deliveries ||= Delivery.includes(:user, receipts: :user).delivered_on(params[:date])
  end
end

class DeliveriesController < InheritedResources::Base
  respond_to :html, :json
  authorize_resource

  def create
    create!(notice: 'Notifications Sent', error: 'Unable to log delivery.') do
      PackageMailer.send_receipts(resource)
      new_delivery_path
    end
  end

  private

  def begin_of_association_chain
    current_user
  end

  def collection
    @deliveries ||= Delivery.delivered_on(params[:date])
  end
end

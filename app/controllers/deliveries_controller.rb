class DeliveriesController < InheritedResources::Base
  respond_to :html, :json
  authorize_resource

  def create
    create!(notice: 'Notifications Sent', error: 'Unable to log delivery.') do
      new_delivery_path
    end
  end

  private

  def create_resource(object)
    object.receipts_attributes = params[:receipts]
    object.save
  end

  def begin_of_association_chain
    current_user
  end

  def collection
    @deliveries ||= Delivery.delivered_on(params[:date])
  end
end

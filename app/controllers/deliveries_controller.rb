class DeliveriesController < InheritedResources::Base
  respond_to :html, :json
  authorize_resource

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
    DeliveryDecorator.decorate Delivery.delivered_on(params[:date])
  end
end

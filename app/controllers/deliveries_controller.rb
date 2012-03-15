class DeliveriesController < ApplicationController
  respond_to :html, :json
  authorize_resource
  expose(:search) { Delivery.search(params[:q]) }
  expose(:search_attribute) { search.base[:delivered_on_eq] }
  expose(:deliveries) { DeliveryDecorator.decorate(search.result.includes(:worker, :receipts)) }
  expose(:delivery)

  def create
    current_user.deliveries.create!(params[:delivery])
    respond_with(delivery)
  end
end

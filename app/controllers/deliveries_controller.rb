class DeliveriesController < ApplicationController
  expose(:search) { Delivery.search(params[:q]) }
  expose(:deliveries) { DeliveryDecorator.decorate(search.result.includes(:worker, :receipts)) }
end

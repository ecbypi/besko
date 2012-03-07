class DeliveriesController < ApplicationController
  expose(:search) { Delivery.search(params[:q]) }
  expose(:search_attribute) { search.base[:created_at_on] }
  expose(:deliveries) { DeliveryDecorator.decorate(search.result.includes(:worker, :receipts)) }
end

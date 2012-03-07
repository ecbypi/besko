class DeliveriesController < ApplicationController
  expose(:search) { Delivery.search(params[:q]) }
  expose(:search_attribute) { search.base[:delivered_on_eq] }
  expose(:deliveries) { DeliveryDecorator.decorate(search.result.includes(:worker, :receipts)) }
end

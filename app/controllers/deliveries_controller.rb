class DeliveriesController < ApplicationController
  layout :determine_layout

  responders :flash, :collection
  respond_to :html

  authorize_resource

  helper_method :receipts_for_new_delivery
  hide_action :receipts_for_new_delivery

  def index
    deliveries = Delivery.includes(:user, receipts: :user).
      waiting_for_pickup.
      page(params[:page]).
      per(20)

    case params[:sort] || cookies[:delivery_sort]
    when nil, 'newest'
      deliveries = deliveries.order(created_at: :desc)
    else
      deliveries = deliveries.order(:created_at)
    end

    @deliveries = PaginatingDecorator.decorate(deliveries)
  end

  def create
    delivery = current_user.deliveries.create(delivery_params)

    if delivery.persisted?
      delivery.receipt_ids.each do |receipt_id|
        Mailer.delay.package_confirmation(receipt_id)
      end
    end

    respond_with(delivery)
  end

  def destroy
    delivery = Delivery.find(params[:id])
    delivery.destroy

    respond_with(delivery, location: deliveries_path(sort: cookies[:delivery_sort]))
  end

  private

  def receipts_for_new_delivery
    @receipts_for_new_delivery ||= begin
      recipients = params.fetch(:r, {})

      users = User.where(id: recipients.keys)
      users.map do |user|
        number_packages = recipients.fetch(user.id.to_s, 1).to_i
        Receipt.new(user: user, number_packages: number_packages)
      end
    end
  end

  def delivery_params
    params.require(:delivery).permit(:deliverer, receipts_attributes: [:user_id, :number_packages, :comment])
  end

  def determine_layout
    request.headers['X-PJAX'] ? false : 'application'
  end
end

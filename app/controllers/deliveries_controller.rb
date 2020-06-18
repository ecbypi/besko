class DeliveriesController < ApplicationController
  responders :flash, :collection
  respond_to :html

  authorize_resource

  def index
    deliveries = Delivery.
      includes(:user, receipts: :user).
      page(params[:page]).
      per(20)

    @query = DeliveryQuery.new(params, deliveries)
    @deliveries = @query.result

    if request.headers["X-PJAX"]
      render(
        partial: "search_results",
        layout: false,
        locals: {
          deliveries: @deliveries,
          query: @query
        }
      )
    else
      respond_with(@deliveries)
    end
  end

  def new
    @delivery = Delivery.new

    recipients = params.fetch(:r, {})

    users = User.where(id: recipients.keys)
    users.each do |user|
      number_packages = recipients.fetch(user.id.to_s, 1).to_i
      @delivery.receipts.build(user: user, number_packages: number_packages)
    end
  end

  def create
    delivery = current_user.deliveries.create(delivery_params)

    if delivery.persisted?
      delivery.receipt_ids.each do |receipt_id|
        Mailer.package_confirmation(receipt_id).deliver_later
      end
    end

    respond_with(delivery)
  end

  def destroy
    delivery = Delivery.find(params[:id])
    delivery.destroy

    respond_with(delivery, location: request.referrer)
  end

  private

  def delivery_params
    params.require(:delivery).permit(:deliverer, receipts_attributes: [:user_id, :number_packages, :comment])
  end
end

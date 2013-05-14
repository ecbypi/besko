class DeliveriesController < ApplicationController
  respond_to :html, :json
  authorize_resource

  def index
    deliveries = Delivery.includes(:user, receipts: :user).delivered_on(params[:date])

    respond_with(deliveries)
  end

  def new
    ids = (cookies['recipients'] || '').split(',')
    @recipients = ActiveModel::ArraySerializer.new(User.find(ids))
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
    Delivery.delete(params[:id])

    head :no_content
  end

  private

  def delivery_params
    params.require(:delivery).permit(:deliverer, receipts_attributes: [:user_id, :number_packages, :comment])
  end
end

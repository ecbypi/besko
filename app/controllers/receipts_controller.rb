class ReceiptsController < ApplicationController
  responders :flash
  respond_to :html

  authorize_resource

  def index
    receipts = current_user.receipts
      .includes(delivery: :user)
      .page(params[:page]).per(10)

    @receipts = PaginatingDecorator.decorate(receipts)
  end

  def new
    user = User.find(params[:user_id])
    receipt = Receipt.new(user: user, number_packages: 1)

    render partial: 'form', layout: false, locals: { receipt: receipt }
  end

  def update
    @receipt = Receipt.find(params[:id])
    @receipt.update!(signed_out_at: Time.zone.now)

    respond_with(@receipt, location: request.referrer)
  end

  private

  def interpolation_options
    { recipient: @receipt.user.name, deliverer: @receipt.delivery.deliverer }
  end
end

class ReceiptsController < InheritedResources::Base
  authorize_resource

  def new
    user = User.find(params[:user_id])
    @receipt = Receipt.new(user: user, number_packages: 1)

    render partial: 'form', layout: false, locals: { receipt: @receipt }
  end

  def update
    resource.update(signed_out_at: Time.zone.now)

    respond_with(resource.delivery)
  end

  private

  def collection
    @receipts ||= begin
      receipts = current_user.receipts
      receipts = receipts.includes(delivery: :user)
      receipts = receipts.page(params[:page]).per(10)
      PaginatingDecorator.decorate(receipts)
    end
  end

  def interpolation_options
    { recipient: resource.user.name, deliverer: resource.delivery.deliverer }
  end
end

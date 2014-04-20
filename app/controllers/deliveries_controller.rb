class DeliveriesController < InheritedResources::Base
  layout :determine_layout

  authorize_resource


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
    resource.destroy

    respond_with(resource, location: deliveries_path(date: resource.delivered_on, sort: cookies[:delivery_sort]))
  end

  private

  def resource
    @delivery ||= super.decorate
  end

  def collection
    @deliveries ||= begin
      deliveries = Delivery.includes(:user, receipts: :user)
      deliveries = deliveries.delivered_on(params[:date])

      case params[:sort] || cookies[:delivery_sort]
      when nil, 'newest'
        deliveries = deliveries.order { created_at.desc }
      else
      end

      deliveries.decorate
    end
  end

  def delivery_params
    params.require(:delivery).permit(:deliverer, receipts_attributes: [:user_id, :number_packages, :comment])
  end

  def determine_layout
    request.headers['X-PJAX'] ? false : 'application'
  end
end

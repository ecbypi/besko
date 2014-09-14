class DeliveriesController < ApplicationController
  responders :flash, :collection
  respond_to :html

  authorize_resource

  helper_method :receipts_for_new_delivery, :delivery_search_params
  hide_action :receipts_for_new_delivery, :delivery_search_params

  def index
    cookies[:delivery_sort] ||= DeliveryQuery::SORT_OPTIONS[:desc]

    deliveries = Delivery.
      includes(:user, receipts: :user).
      paraphrase(delivery_search_params).
      page(params[:page]).
      per(20)

    @deliveries = PaginatingDecorator.decorate(deliveries)

    if request.headers["X-PJAX"]
      render(
        partial: "search_results",
        layout: false,
        locals: { deliveries: @deliveries }
      )
    else
      respond_with(@deliveries)
    end
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

  def delivery_search_params
    @delivery_search_params ||= begin
      filtered_params = params.slice(*DeliveryQuery.keys)
      filtered_params.reverse_merge(
        sort: cookies[:delivery_sort],
        filter: DeliveryQuery::FILTER_OPTIONS[:waiting]
      )
    end
  end

  def delivery_params
    params.require(:delivery).permit(:deliverer, receipts_attributes: [:user_id, :number_packages, :comment])
  end
end

class ReceiptsController < InheritedResources::Base
  respond_to :html, :js, :json

  authorize_resource

  private

  def smart_resource_url
    receipts_path(page: params[:page])
  end

  def update_resource(object, *attributes)
    object.sign_out!
  end

  def collection
    @receipts ||= begin
      receipts = current_user.receipts
      receipts = receipts.includes(delivery: :user)
      receipts = receipts.page(params[:page]).per(10)
      PaginatingDecorator.decorate(receipts)
    end
  end
end

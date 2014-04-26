class ReceiptsController < InheritedResources::Base
  layout :determine_layout

  respond_to :html, :js, :json

  authorize_resource

  def new
    user = User.find(params[:user_id])
    @receipt = Receipt.new(user: user)
  end

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

  def determine_layout
    params[:action] == 'new' ? false : 'application'
  end
end

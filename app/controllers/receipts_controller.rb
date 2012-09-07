class ReceiptsController < InheritedResources::Base
  respond_to :html, :js, :json

  actions :all, except: [:show]
  load_and_authorize_resource

  def new
    user = if params[:user_id]
      User.find(params[:user_id])
    elsif params[:user]
      User.create_with_or_without_password(params[:user])
    end

    resource.recipient = user
    super
  end

  def update
    resource.sign_out!
    update!(notice: 'Package Signed Out')
  end

  private

  def collection
    ReceiptDecorator.decorate(current_user.receipts.includes{delivery.worker})
  end
end

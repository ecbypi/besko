class ReceiptsController < InheritedResources::Base
  respond_to :html, :js, :json

  actions :all, except: [:show]
  load_and_authorize_resource

  def new
    if params[:user_id]
      user = User.find(params[:user_id])
    elsif params[:user]
      user = User.assign_password(params[:user])
      user.skip_confirmation!
      user.save
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

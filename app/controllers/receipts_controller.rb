class ReceiptsController < InheritedResources::Base
  respond_to :html, :js, :json

  actions :all, except: [:show]
  authorize_resource

  def new
    if params[:user_id]
      user = User.find(params[:user_id])
    elsif params[:user]
      user = User.new(params[:user])
      user.assign_password.skip_confirmation_email!
      user.save
    end

    build_resource.recipient = user
    super
  end

  def update
    resource.sign_out!
    update!(notice: 'Package Signed Out')
  end

  protected

  def collection
    get_collection_ivar || begin
      records = current_user.receipts.
        includes(delivery: :user).
        page(params[:page]).per(10)

      @receipts = ReceiptDecorator.decorate(records)
    end
  end
end

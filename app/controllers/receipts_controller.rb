class ReceiptsController < InheritedResources::Base
  respond_to :html, :js, :json

  actions :all, except: [:show]
  authorize_resource

  helper_method :decorated_collection
  hide_action :decorated_collection

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
    update!(notice: 'Package Signed Out') { receipts_path(page: params[:page]) }
  end

  private

  def decorated_collection
    @decorated_receipts ||= collection.decorate
  end

  def collection
    get_collection_ivar || begin
      @receipts = current_user.receipts.
        includes(delivery: :user).
        page(params[:page]).per(10)
    end
  end
end

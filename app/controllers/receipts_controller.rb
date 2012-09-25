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

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
    records = super.includes(:delivery => :worker).page(params[:page]).per(10)
    ReceiptDecorator.decorate(records)
  end
end

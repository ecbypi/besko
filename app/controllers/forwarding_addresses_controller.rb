class ForwardingAddressesController < ApplicationController
  self.responder = ForwardingAddressResponder
  respond_to :html, only: [:create, :update]
  respond_to :json, only: :index

  before_filter :authenticate_user!

  def index
    authorize! :read, ForwardingAddress

    respond_with(ForwardingAddress.includes(:user).search(params[:q]))
  end

  def create
    current_user.create_forwarding_address(address_params)
    respond_with(current_user.forwarding_address)
  end

  def update
    current_user.forwarding_address.update_attributes(address_params)
    respond_with(current_user.forwarding_address)
  end

  def subregions
    render partial: 'devise/registrations/subregion_select'
  end

  private

  def address_params
    params.require(:forwarding_address).permit(:street, :city, :state, :country, :postal_code)
  end
end

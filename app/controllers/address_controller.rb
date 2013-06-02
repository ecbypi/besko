class AddressController < ApplicationController
  self.responder = AddressResponder
  respond_to :html, only: [:create, :update]

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

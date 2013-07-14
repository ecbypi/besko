class MailForwardingController < ApplicationController
  authorize_resource class: :forwarding_label

  def new
    Rails.logger.debug cookies['forwardingState']
    mappings  = JSON.parse(cookies['addresses']) rescue {}
    ids       = mappings.keys
    addresses = ForwardingAddress.find(ids)

    @addresses = ActiveModel::ArraySerializer.new(addresses, mappings: mappings)
  end
end

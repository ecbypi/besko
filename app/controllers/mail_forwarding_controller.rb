class MailForwardingController < ApplicationController
  authorize_resource class: :forwarding_label
end

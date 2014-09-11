class ReceiptDecorator < ApplicationDecorator
  def delivery_details_css_class
    if object.signed_out?
      "delivery-signed-out-receipt"
    end
  end
end

module ReceiptsHelper
  def receipt_delivery_details_css_class(receipt)
    if receipt.signed_out?
      "delivery-signed-out-receipt"
    end
  end

  def receipt_field_id(receipt, attribute)
    "receipt_#{receipt.user_id}_#{attribute}"
  end
end

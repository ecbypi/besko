module ReceiptsHelper
  def receipt_field_id(receipt, attribute)
    "receipt_#{receipt.recipient_id}_#{attribute}"
  end
end

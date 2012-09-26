module ReceiptsHelper
  def receipt_field_id(receipt, attribute)
    "receipt_#{receipt.recipient_id}_#{attribute}"
  end

  def link_to_previous_page
    if current_page > 1
      link_to 'Previous', receipts_path(page: current_page - 1), class: 'prev-page button'
    end
  end

  def link_to_next_page
    if collection.to_a.size == 10
      link_to 'Next', receipts_path(page: current_page + 1), class: 'next-page button'
    end
  end

  def current_page
    params.fetch(:page, 1).to_i
  end
end

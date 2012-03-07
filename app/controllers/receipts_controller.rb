class ReceiptsController < InheritedResources::Base
  actions :all, except: [:show]

  def update
    resource.sign_out!
    update!(notice: 'Package Signed Out')
  end

  private

  def collection
    ReceiptDecorator.decorate(current_user.receipts.includes{delivery.worker})
  end
end

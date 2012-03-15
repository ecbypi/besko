class ReceiptsController < InheritedResources::Base
  actions :all, except: [:show]
  load_and_authorize_resource

  def update
    resource.sign_out!
    update!(notice: 'Package Signed Out')
  end

  private

  def collection
    ReceiptDecorator.decorate(current_user.receipts.includes{delivery.worker})
  end
end

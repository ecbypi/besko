class PackagesController < InheritedResources::Base
  actions :all, except: [:show]

  def update
    resource.sign_out!
    update!(notice: 'Package Signed Out')
  end

  private

  def collection
    PackageDecorator.decorate(current_user.received_packages.includes(:worker))
  end
end

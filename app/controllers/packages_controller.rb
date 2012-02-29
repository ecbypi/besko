  expose(:package)
  expose(:packages) { current_user.received_packages.includes(:worker) }
class PackagesController < InheritedResources::Base

  def update
    package.sign_out!
    respond_to do |format|
      format.html { redirect_to packages_path, :notice => "Package Signed Out" }
    end
  end
end

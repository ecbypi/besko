class PackagesController < ApplicationController
  expose(:package)
  expose(:packages) { current_user.received_packages.includes(:worker) }

  def update
    package.sign_out!
    respond_to do |format|
      format.html { redirect_to packages_path, :notice => "Package Signed Out" }
    end
  end
end

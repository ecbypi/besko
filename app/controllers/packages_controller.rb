class PackagesController < ApplicationController
  expose(:package)
  expose(:received_packages) { current_user.received_packages.includes(:worker) }

  def update
    package.sign_out!
    respond_to do |format|
      format.html { redirect_to '/packages', :notice => "Signed out package" }
      format.js
    end
  end
end

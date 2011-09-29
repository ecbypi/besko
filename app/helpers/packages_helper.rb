module PackagesHelper

  def signed_out_at(package)
    time = package.signed_out_at.strftime("%Y-%m-%d at %r")
    "Signed out on #{time}"
  end
end

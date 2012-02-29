class WorkerPackagesController < ApplicationController
  expose(:search) { Package.search(params[:search]) }
  expose(:date) { search.search_attributes["received_on_equals"] || Time.zone.now.to_date }
  expose(:packages) do
    packages = if params[:search]
      search.relation
    else
      Package.for_date
    end

    PackageDecorator.decorate(packages)
  end
end

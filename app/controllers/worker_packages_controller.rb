class WorkerPackagesController < ApplicationController
  expose(:search) { Package.search(params[:search]) }
  expose(:date) { search.search_attributes["received_on_equals"] || Time.zone.now.to_date }
  expose(:packages) do
    if params[:search]
      search.relation
    else
      Package.for_date
    end
  end
end

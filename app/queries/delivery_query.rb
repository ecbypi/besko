class DeliveryQuery < Paraphrase::Query
  SORT_OPTIONS = {
    asc: "oldest",
    desc: "newest"
  }

  FILTER_OPTIONS = {
    all: "all",
    waiting: "waiting"
  }

  map :filter, to: :filtered_by
  map :sort, to: :sorted_by
  map :delivered_by, to: :with_deliverer

  scope :filtered_by do |filter|
    if filter == FILTER_OPTIONS[:waiting]
      relation.waiting_for_pickup
    else
      relation
    end
  end

  scope :sorted_by do |sort_direction|
    if sort_direction == SORT_OPTIONS[:desc]
      relation.order(updated_at: :desc)
    else
      relation.order(:updated_at)
    end
  end

  scope :with_deliverer do |deliverer|
    relation.where(deliverer: deliverer)
  end

  param :sort do
    params[:sort].presence || DeliveryQuery::SORT_OPTIONS[:desc]
  end

  param :filter do
    params[:filter].presence || DeliveryQuery::FILTER_OPTIONS[:waiting]
  end
end

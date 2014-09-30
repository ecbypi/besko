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
  map :received_by, to: :received_by
  map :delivered_to, to: :with_recipient

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

  scope :received_by do |desk_worker_id|
    relation.where(user_id: desk_worker_id)
  end

  scope :with_recipient do |recipient_id|
    relation.joins(:receipts).where(receipts: { user_id: recipient_id })
  end

  param :sort do
    params[:sort].presence || DeliveryQuery::SORT_OPTIONS[:desc]
  end

  param :filter do
    params[:filter].presence || DeliveryQuery::FILTER_OPTIONS[:waiting]
  end
end

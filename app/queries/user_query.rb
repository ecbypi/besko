class UserQuery < Paraphrase::Query
  map :term, to: :search
  map :category, to: :filtered_by_category

  scope :filtered_by_category do |category|
    case category
    when 'desk_worker'
      relation.joins(:deliveries)
    when 'recipient'
      relation.joins(:receipts)
    else
      relation
    end
  end
end

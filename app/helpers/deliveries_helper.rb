module DeliveriesHelper
  def delivery_search_results_css_class
    css_class = "deliveries-listing"

    if delivery_search_params[:filter] == "all"
      css_class << " all-deliveries-listing"
    end

    css_class
  end

  def delivery_search_filter_options
    @delivery_search_filter_options ||=
      DeliveryQuery::FILTER_OPTIONS.map do |key, value|
        [t(".delivery_search.filter_labels.#{key}"), value]
      end
  end

  def delivery_search_sort_options
    @delivery_search_sort_options ||=
      DeliveryQuery::SORT_OPTIONS.map do |key, value|
        [t(".delivery_search.sort_labels.#{key}"), value]
      end
  end

  def delivery_search_deliverer_options
    Delivery::Deliverers
  end
end

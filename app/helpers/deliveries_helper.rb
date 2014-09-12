module DeliveriesHelper
  FILTER_OPTIONS = %w( waiting all )
  SORT_OPTIONS = %w( newest oldest )

  def delivery_search_params
    @delivery_search_params ||= params.slice(:page, :sort, :filter).reverse_merge(
      sort: cookies[:delivery_sort],
      fitler: "waiting"
    )
  end

  def delivery_search_results_css_class
    css_class = "deliveries-listing"

    if delivery_search_params[:filter] == "all"
      css_class << " all-deliveries-listing"
    end

    css_class
  end

  def delivery_search_filter_options
    @delivery_search_filter_options ||= FILTER_OPTIONS.map do |value|
      [t(".delivery_search.filter_labels.#{value}"), value]
    end
  end

  def delivery_search_sort_options
    @delivery_search_sort_options ||= SORT_OPTIONS.map do |value|
      [t(".delivery_search.sort_labels.#{value}"), value]
    end
  end
end

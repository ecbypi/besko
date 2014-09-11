module DeliveriesHelper
  def delivery_search_params
    @search_params ||= params.slice(:page, :sort).reverse_merge(
      sort: cookies[:delivery_sort]
    )
  end

  def delivery_search_params_with_reverse_sorting
    direction = delivery_search_params[:sort] == "oldest" ? "newest" : "oldest"
    delivery_search_params.merge(sort: direction)
  end

  def delivery_sorting_css_class
    css_class = 'sort-column'

    if delivery_search_params[:sort] == "oldest"
      css_class << ' up'
    end

    css_class
  end
end

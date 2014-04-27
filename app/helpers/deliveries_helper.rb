module DeliveriesHelper
  DATE_FORMAT = '%Y-%m-%d'

  def formatted_delivered_on
    delivered_on.strftime('%a, %b %d, %Y')
  end

  def delivered_on
    @delivered_on ||= if params.key?(:date)
      Time.zone.parse(params[:date]).to_date
    else
      Time.zone.now.to_date
    end
  end

  def next_date_params
    next_date = (delivered_on + 1).strftime(DATE_FORMAT)
    search_params.merge(date: next_date)
  end

  def previous_date_params
    previous_date = (delivered_on - 1).strftime(DATE_FORMAT)
    search_params.merge(date: previous_date)
  end

  def reverse_sort_params
    sort_direction = search_params[:sort] == 'oldest' ? 'newest' : 'oldest'
    search_params.merge(sort: sort_direction)
  end

  def search_params
    @search_params ||= params.slice(:date, :sort).reverse_merge(
      sort: cookies[:delivery_sort]
    )
  end

  def sorting_css_class
    css_class = 'sort-column'

    if search_params[:sort] == 'oldest'
      css_class << ' up'
    end

    css_class
  end
end

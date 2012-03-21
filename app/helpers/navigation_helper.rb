module NavigationHelper

  def navigation
    list_items navigation_paths, class: 'section' do |title, path|
      index = navigation_paths.index([title, path])
      [link_to(title, path), sub_navigation(index)].join.html_safe
    end
  end

  def sub_navigation(index)
    content_tag :nav, class: 'sub' do
      content_tag :ul do
        list_items sub_paths[index]
      end
    end if sub_paths[index].present?
  end

  def list_items(paths, options={})
    paths.collect do |title, path|
      options[:class] = "#{options[:class]} #{'active' if path == request.path}"
      content_tag :li, options do
        if block_given?
          yield title, path
        else
          link_to(title, path)
        end
      end
    end.join.html_safe
  end

  def navigation_paths
    [
      ['Packages', receipts_path],
      ['Deliveries', deliveries_path]
    ]
  end

  def sub_paths
    [
      [],
      deliveries_paths
    ]
  end

  def deliveries_paths
    [
      ['Review', deliveries_path],
      ['New Delivery', new_delivery_path]
    ]
  end
end

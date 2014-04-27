module ApplicationHelper
  def bootstrap(data)
    content_for(:bootstrap) do
      content_tag(:script, id: 'bootstrap', type: 'text/json') do
        "{ \"data\" : #{ data.to_json } }"
      end
    end
  end

  def bootstrap_collection
    data = ActiveModel::ArraySerializer.new(collection)
    bootstrap(data)
  end

  def body_css_class
    css_class = "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"

    if current_user && current_user.admin?
      css_class << ' admin'
    end

    css_class
  end
end

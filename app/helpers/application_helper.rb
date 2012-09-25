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
end

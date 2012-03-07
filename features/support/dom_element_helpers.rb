module DOMElementHelpers

  def model_collection name
    find :model_collection, name.pluralize
  end

  def model_resource text
    find '[data-resource-id]', text: text
  end

  ['receipt', 'delivery'].each do |model_name|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{model_name.pluralize}_collection
        model_collection '#{model_name.pluralize}'
      end
    METHODS
  end
end

World(DOMElementHelpers)

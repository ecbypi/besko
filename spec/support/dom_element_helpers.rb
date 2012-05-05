module DOMElementHelpers

  def model_collection name
    find :model_collection, name.pluralize
  end

  def model_element name, text=nil
    if text
      find :model_element, name, text: text
    else
      find :model_element, name
    end
  end

  def model_resource text
    find '[data-resource-id]', text: text
  end

  ['receipt', 'delivery', 'recipient', 'user'].each do |model_name|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{model_name.pluralize}_collection
        model_collection '#{model_name.pluralize}'
      end

      def #{model_name}_element text=nil
        model_element '#{model_name}', text
      end
    METHODS
  end

  def recipient_section name
    find "li[data-recipient='#{name}']"
  end
end

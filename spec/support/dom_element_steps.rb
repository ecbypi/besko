module DOMElementSteps
  def notifications
    find('#notifications')
  end

  def navigation
    find('#primary')
  end

  def model_collection(model_name)
    find(:model_collection, model_name.pluralize)
  end

  def have_model_collection(model_name)
    have_selector(:model_collection, text: model_name.pluralize)
  end

  def model_element(model_name, text = nil)
    if text
      find(:model_element, model_name, text: text)
    else
      find(:model_element, model_name)
    end
  end

  def have_model_element(model_name, options)
    have_selector :model_element, model_name, options
  end

  %w( receipt delivery recipient user user_role ).each do |model_name|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{model_name.pluralize}_collection
        model_collection('#{model_name.pluralize}')
      end

      def have_#{model_name.pluralize}_collection
        have_model_collection('#{model_name.pluralize}')
      end

      def #{model_name}_element(text = nil)
        model_element('#{model_name}', text)
      end

      def have_#{model_name}_element(options)
        have_model_element('#{model_name}', options)
      end
    METHODS
  end
end

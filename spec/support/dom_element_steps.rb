module DOMElementSteps
  RESOURCES = %w( receipt delivery recipient user user_role forwarding_address forwarding_label )

  def notifications
    find('#notifications')
  end

  def navigation
    find('.primary-nav')
  end

  def model_collection(model_name)
    find(:model_collection, model_name.pluralize)
  end

  def have_model_collection(model_name)
    have_selector(:model_collection, text: model_name.pluralize)
  end

  def model_element(model_name, options = {})
    find(:model_element, model_name, options)
  end

  def have_model_element(model_name, options)
    have_selector :model_element, model_name, options
  end

  RESOURCES.each do |model_name|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{model_name.pluralize}_collection
        model_collection('#{model_name.pluralize}')
      end

      def have_#{model_name.pluralize}_collection
        have_model_collection('#{model_name.pluralize}')
      end

      def #{model_name}_element(options = {})
        model_element('#{model_name}', options)
      end

      def have_#{model_name}_element(options)
        have_model_element('#{model_name}', options)
      end
    METHODS
  end
end

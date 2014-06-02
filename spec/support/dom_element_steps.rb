Capybara.add_selector(:models_element) do
  xpath { |name| XPath.css("[data-collection='#{name}']") }
end

Capybara.add_selector(:model_element) do
  xpath { |name| XPath.css("[data-resource='#{name}']") }
end

module DOMElementSteps
  RESOURCES = %w( receipt delivery recipient user user_role )

  def notifications
    find('#notifications')
  end

  def navigation
    find('.primary-nav')
  end

  def models_element(model_name)
    find(:models_element, model_name.pluralize)
  end

  def have_models_element(model_name)
    have_selector(:models_element, text: model_name.pluralize)
  end

  def model_element(model_name, options = {})
    find(:model_element, model_name, options)
  end

  def have_model_element(model_name, options)
    have_selector :model_element, model_name, options
  end

  RESOURCES.each do |model_name|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{model_name.pluralize}_element
        models_element('#{model_name.pluralize}')
      end

      def have_#{model_name.pluralize}_element
        have_models_element('#{model_name.pluralize}')
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
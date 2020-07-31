class HumanAttributeName
  include ActiveModel::Translation

  def initialize(model, attribute, options = {})
    @model = model
    @attribute = [options.delete(:scope), attribute].compact.join(".")
    @options = options

    if @model.class < ActiveModel::Translation
      @options[:default] ||= @model.class.human_attribute_name(@attribute, @options)
    end
  end

  def to_s
    human_attribute_name(@attribute, @options)
  end

  def i18n_scope
    :actionview
  end

  def lookup_ancestors
    @model.class.lookup_ancestors
  end
end

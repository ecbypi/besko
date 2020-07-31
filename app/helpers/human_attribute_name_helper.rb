module HumanAttributeNameHelper
  def human_attribute_name(model, attribute, options = {})
    HumanAttributeName.new(model, attribute, options).to_s
  end
end

Capybara.add_selector(:model_collection) do
  xpath { |name| XPath.css("[data-collection='#{name}']") }
end

Capybara.add_selector(:model_element) do
  xpath { |name| XPath.css("[data-resource='#{name}']") }
end

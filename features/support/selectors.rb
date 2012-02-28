Capybara.add_selector(:model_collection) do
  xpath { |name| XPath.css("[data-collection='#{name}']") }
end

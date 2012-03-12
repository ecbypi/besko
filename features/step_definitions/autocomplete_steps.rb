Then /^I should see "([^"]*)" in the autocomplete list$/ do |name|
  within 'ul.ui-autocomplete' do
    page.should have_css 'li.ui-menu-item', text: name
  end
end

When /^I click on "([^"]*)" in the autocomplete list$/ do |name|
  within 'ul.ui-autocomplete' do
    find('a', text: name).click
  end
end

Then /^I should not see "([^"]*)" in the autocomplete form$/ do |name|
  find('.ui-autocomplete-input').value.should be_empty
end

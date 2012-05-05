step "I should see :name in the autocomplete list" do  |name|
  within 'ul.ui-autocomplete' do
    page.should have_css 'li.ui-menu-item', text: name
  end
end

step "I click on :name in the autocomplete list" do  |name|
  sleep 1
  within 'ul.ui-autocomplete' do
    find('a', text: name).click
  end
end

step "I should not see :name in the autocomplete form" do  |name|
  find('.ui-autocomplete-input').value.should be_empty
end

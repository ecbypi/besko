step "I click on :name in the autocomplete list" do  |name|
  sleep 1
  within '.autocomplete-results-wrapper' do
    user_element(name).click
  end
end

When /^I look in the touchstone login form$/ do
  page.should have_css 'form[action="/touchstone"]'
end

Then /^I should see a button to login via touchstone$/ do
  within 'form[action="/touchstone"]' do
    page.should have_button 'Sign In with Touchstone'
  end
end

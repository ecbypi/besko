steps_for :touchstone do
  step "I look in the touchstone login form" do
    page.should have_css 'form[action="/touchstone"]'
  end

  step "I should see a button to login via touchstone" do
    within 'form[action="/touchstone"]' do
      page.should have_button 'Sign In with Touchstone'
    end
  end
end

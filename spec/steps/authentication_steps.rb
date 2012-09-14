step "I should not see the URL to :url_action" do |path|
  page.should_not have_css "a[href='#{path}']"
end

step "I should be redirected to the home page" do
  current_path.should eq root_path
  step "I should see an error message"
end

placeholder :url_action do
  match /create deliveries/ do
    '/deliveries/new'
  end

  match /review deliveries/ do
    '/deliveries'
  end

  match /review receipts/ do
    '/receipts'
  end
end

step "I should not see the URL to :url_action" do |path|
  page.should_not have_css "a[href='#{path}']"
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

Then /^I should see the (?:error|notice) "([^"]*)"$/ do |message|
  within "#notifications" do
    page.should have_content message
  end
end

step "I should see the error/notice :message" do  |message|
  within "#notifications" do
    page.should have_content message
  end
end

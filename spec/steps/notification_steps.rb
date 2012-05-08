step "I should see the error/notice :message" do  |message|
  within "#notifications" do
    page.should have_content message
  end
end

step "I should see a(n) :message_type message" do |message_type|
  within "#notifications" do
    page.should have_css "div.message.#{message_type}"
  end
end

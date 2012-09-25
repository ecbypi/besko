step "I go to the :direction page of receipts" do |direction|
  click_link direction
end

placeholder :direction do
  match /\w+/ do |direction|
    direction.titleize
  end
end

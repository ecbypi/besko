placeholder :number do
  match /\d+/ do |number|
    number.to_i
  end
end

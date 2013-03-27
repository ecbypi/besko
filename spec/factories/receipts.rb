FactoryGirl.define do

  factory :receipt do
    delivery
    user
    number_packages 1
    comment "Heavy!"
  end
end

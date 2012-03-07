FactoryGirl.define do

  factory :receipt do
    association :delivery
    association :recipient, factory: :user
    number_packages 1
    comment "Heavy!"
  end
end

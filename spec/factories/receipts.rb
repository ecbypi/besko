FactoryGirl.define do
  factory :receipt do
    delivery
    user
    number_packages { (1..10000).to_a.sample }
    comment "Heavy!"

    trait :signed_out do
      signed_out_at { Time.zone.now }
    end
  end
end

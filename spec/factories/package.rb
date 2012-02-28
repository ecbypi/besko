FactoryGirl.define do
  factory :package do
    delivered_by "UPS"
    comment "Perishable"
    received_on Time.zone.now.to_date - 1.day
    signed_out_at nil
    association :worker, factory: :user
    association :recipient, factory: :user
  end

  factory :signed_out_package, parent: :package do
    signed_out_at Time.zone.now.to_date
  end
end

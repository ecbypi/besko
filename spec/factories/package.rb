FactoryGirl.define do
  factory :base_package do |package|
    package.delivered_by "UPS"
    package.comment "Perishable.  Come pick up soon"
    package.received Date.today
    package.signed_out_at nil
  end

  factory :package, :parent => :base_package do |package|
    package.association :worker, :factory => :user
    package.association :recipient, :factory => :user
  end

  factory :signed_out_package, :parent => :package do |package|
    package.signed_out_at DateTime.now - 5.days
  end
end

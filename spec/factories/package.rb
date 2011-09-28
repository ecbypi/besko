FactoryGirl.define do
  factory :base_package, :class => 'Package' do |package|
    package.delivered_by "UPS"
    package.comment "Perishable.  Come pick up soon"
    package.received_on Time.zone.now.to_date - 1.day
    package.signed_out_at nil
  end

  factory :package, :parent => :base_package do |package|
    package.association :worker, :factory => :user
    package.association :recipient, :factory => :user
  end

  factory :signed_out_package, :parent => :package do |package|
    package.signed_out_at Time.zone.now.to_date
  end
end

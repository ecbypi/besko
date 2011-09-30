FactoryGirl.define do
  factory :base_package, :class => 'Package' do |package|
    package.delivered_by "UPS"
    package.comment "Perishable"
    package.received_on Time.zone.now.to_date - 1.day
    package.signed_out_at nil
  end

  factory :package, :parent => :base_package do |package|
    package.association :worker, :factory => :approved_user
    package.association :recipient, :factory => :approved_user
  end

  factory :signed_out_package, :parent => :package do |package|
    package.signed_out_at Time.zone.now.to_date
  end
end

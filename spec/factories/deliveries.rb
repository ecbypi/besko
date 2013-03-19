FactoryGirl.define do
  factory :delivery do
    ignore do
      delivered { Time.zone.today }
    end

    delivered_on do |proxy|
      proxy.created_at ? proxy.created_at.to_date : proxy.delivered
    end

    association :worker, factory: :user
    deliverer "FedEx"
  end
end

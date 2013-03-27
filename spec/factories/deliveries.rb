FactoryGirl.define do
  factory :delivery do
    ignore do
      delivered { Time.zone.today }
    end

    delivered_on do |proxy|
      proxy.created_at ? proxy.created_at.to_date : proxy.delivered
    end

    user
    deliverer "FedEx"

    before_create do |delivery, proxy|
      if delivery.receipts.empty?
        delivery.receipts = FactoryGirl.build_list(:receipt, 1, delivery: delivery)
      end
    end
  end
end

FactoryBot.define do
  factory :delivery do
    user
    deliverer { Delivery::Deliverers.sample }

    before(:create) do |delivery, proxy|
      if delivery.receipts.empty?
        delivery.receipts = [build(:receipt, delivery: delivery)]
      end
    end
  end
end

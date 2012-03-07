FactoryGirl.define do

  factory :delivery do
    association :worker, factory: :user
    deliverer "FedEx"
  end
end

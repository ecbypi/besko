FactoryGirl.define do
  factory :forwarding_address do
    user
    street '1221 Commonwealth Ave'
    city 'Boston'
    state 'MA'
    country 'US'
    postal_code '02140'
  end
end

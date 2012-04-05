FactoryGirl.define do
  factory :role do
  end

  factory :user_role do
    association :role
    association :user
  end
end

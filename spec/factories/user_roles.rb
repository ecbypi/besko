FactoryGirl.define do
  factory :user_role do
    sequence(:title) { |n| "Role #{n}" }
    association :user
  end
end

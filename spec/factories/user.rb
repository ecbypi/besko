FactoryGirl.define do
  factory :user do |user|
    user.first_name "First"
    user.last_name "Last Name"
    user.sequence(:login) { |n| "bexley#{n}" }
    user.sequence(:email) { |n| "name@email.com" }
    user.password "password"
    user.password_confirmation "password"
    user.approved true
  end
end

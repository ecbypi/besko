FactoryGirl.define do
  factory :user do |user|
    user.first_name "First"
    user.last_name "Last Name"
    user.login "bexley"
    user.email "name@email.com"
    user.password "password"
    user.password_confirmation "password"
  end
end

FactoryGirl.define do
  factory :unapproved_user, class: 'User' do
    first_name "First"
    last_name "Last Name"
    sequence(:login) { |n| "bexley#{n}" }
    sequence(:email) { |n| "name#{n}@email.com" }
    password "password"
    password_confirmation "password"
    street "77 Mass Ave"

    trait :forwarding_account do
      forwarding_account true
      password nil
      password_confirmation nil
    end
  end

  factory :user, parent: :unapproved_user do
    confirmed_at 1.month.ago

    factory :mrhalp do
      first_name 'Micro'
      last_name 'Helpline'
      email 'mrhalp@mit.edu'
      login 'mrhalp'
      street 'N42'
    end

    factory :mshalp do
      first_name 'Ms'
      last_name 'Helpline'
      email 'mshalp@mit.edu'
      login 'mshalp'
      street 'N42'
    end

    User.guises.each do |guise|
      trait guise.to_s.underscore.to_sym do
        after(:create) do |user, proxy|
          FactoryGirl.create(:user_role, title: guise.to_s, user: user)
        end
      end
    end
  end

  factory :user_role do
    title 'BeskWorker'
    association :user
  end
end

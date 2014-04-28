FactoryGirl.define do
  factory :user do
    first_name "First"
    last_name "Last Name"
    sequence(:login) { |n| "bexley#{n}" }
    sequence(:email) { |n| "name#{n}@email.com" }
    password "password"
    password_confirmation "password"
    street "77 Mass Ave"

    confirmed_at 1.month.ago

    trait :unconfirmed do
      confirmed_at nil
    end

    trait :forwarding_account do
      forwarding_account true
      password nil
      password_confirmation nil
    end

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
      trait_name = guise.underscore.to_sym
      trait trait_name do
        after(:create) do |user, proxy|
          create(:user_role, trait_name, user: user)
        end
      end
    end
  end

  factory :user_role do
    title { User.guises.sample }
    user

    User.guises.each do |guise|
      trait_name = guise.underscore.to_sym
      trait trait_name do
        title guise
      end
    end
  end
end

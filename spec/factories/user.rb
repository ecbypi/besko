FactoryGirl.define do
  factory :unapproved_user, class: 'User' do
    first_name "First"
    last_name "Last Name"
    sequence(:login) { |n| "bexley#{n}" }
    sequence(:email) { |n| "name#{n}@email.com" }
    password "password"
    password_confirmation "password"
    street "77 Mass Ave"
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
  end

end

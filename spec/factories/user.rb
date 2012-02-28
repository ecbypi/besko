FactoryGirl.define do
  factory :unapproved_user, :class => 'User' do
    first_name "First"
    last_name "Last Name"
    sequence(:login) { |n| "bexley#{n}" }
    sequence(:email) { |n| "name#{n}@email.com" }
    password "password"
    password_confirmation "password"
  end

  factory :approved_user, :parent => :unapproved_user do
    confirmed_at Time.zone.now
  end

  factory :user, :parent => :approved_user do
    after_create do
      Factory(:base_package, :recipient => user, :worker => Factory(:approved_user))
      Factory(:base_package, :worker => user, :recipient => Factory(:approved_user))
    end
  end

  factory :besk_worker, :parent => :approved_user do
    roles { [Role.find_by_title("Besk Worker") || Factory(:worker_role)] }
  end
end

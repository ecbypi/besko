FactoryGirl.define do
  factory :unapproved_user, :class => 'User' do |user|
    user.first_name "First"
    user.last_name "Last Name"
    user.sequence(:login) { |n| "bexley#{n}" }
    user.sequence(:email) { |n| "name#{n}@email.com" }
    user.password "password"
    user.password_confirmation "password"
  end

  factory :approved_user, :parent => :unapproved_user do |user|
    user.after_create do |user|
      user.approved = true
      user.save
    end
  end

  factory :user, :parent => :approved_user do |user|
    user.after_create do |user|
      Factory(:base_package, :recipient => user, :worker => Factory(:approved_user))
      Factory(:base_package, :worker => user, :recipient => Factory(:approved_user))
    end
  end

  factory :besk_worker, :parent => :user do |user|
    user.roles { [Role.find_by_title("Besk Worker") || Factory(:worker_role)] }
  end
end

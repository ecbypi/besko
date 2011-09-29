FactoryGirl.define do
  factory :role do |role|
    role.sequence(:title) { |n| "Job #{n}" }
  end

  factory :worker_role, :class => 'Role' do |role|
    role.title "Besk Worker"
  end
end

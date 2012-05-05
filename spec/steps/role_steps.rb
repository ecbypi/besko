step "I am a :role with the email :email" do |role, email|
  user = User.find_by_email!(email)
  user.user_roles.create(title: role)
end

placeholder :role do
  match /([a-z ]+)/ do |role|
    role.gsub(/\s/,'_').classify
  end
end

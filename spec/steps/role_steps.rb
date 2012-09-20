step "I am a/an :role with the email :email" do |role, email|
  user = User.find_by_email!(email)
  user.user_roles.create!(title: role)
end

step ":login is a/an :role" do |login, role|
  user = User.find_by_login!(login)
  user.user_roles.create!(title: role)
end

placeholder :role do
  match /([a-z ]+)/ do |role|
    role.gsub(/\s/,'_').classify
  end
end

namespace :deploy do
  desc "Deploy code in a way that better facilitates git"
  task :setup, roles: :web, except: { no_release: true } do
    run "git clone #{repository} #{current_path}"
  end
end

after "deploy:setup", "deploy:update_code"

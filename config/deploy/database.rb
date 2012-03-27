namespace :deploy do
  namespace :db do
    desc "Setup database"
    task :setup do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:setup"
    end
  end
end

before "deploy:migrate", "deploy:web:disable"
after "deploy:migrate", "deploy:web:enable"

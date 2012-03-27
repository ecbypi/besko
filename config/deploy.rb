# dependencies
require 'bundler/capistrano'

# settings
load 'config/deploy/gitify'
load 'config/deploy/settings'
load 'config/deploy/symlinks'

# database management and callbacks
load 'config/deploy/database'

# custom asset pipeline
load 'config/deploy/assets'

namespace :deploy do
  desc "Deploy code in a way that better facilitates git"
  task :setup, roles: :web, except: { no_release: true } do
    run "git clone #{repository} #{current_path}"
  end

  desc "Update deployed code via fetching"
  task :update_code, roles: :web, except: { no_release: true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
  end

  task :cache_revision, roles: :web, except: { no_release: true } do
    run "cd #{current_path}; echo `git log --pretty=\"%H\" -1` > #{current_path}/REVISION"
  end

  namespace :rollback do
    desc "Rollback"
    task :default, roles: :web, except: { no_release: true } do
      code
    end

    desc "Rollback a single commit"
    task :code, roles: :web, except: { no_release: true } do
      set :branch, "#{branch}^"
      update_code
    end
  end

  task :start do; end
  task :stop do; end

  desc "Touch restart.txt to tell passenger to restart"
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before "deploy:assets:precompile", "bundle:install"
after "deploy:update", "deploy:cache_revision"
after "deploy:setup", "deploy:cache_revision", "deploy:update_code"

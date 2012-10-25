# dependencies
require 'bundler/capistrano'

# settings
load 'config/deploy/settings'
load 'config/deploy/symlinks'

# database management and callbacks
load 'config/deploy/database'

# custom asset pipeline
load 'config/deploy/assets'

# honeybadger configuration/tasks
require './config/boot'
require 'honeybadger/capistrano'

namespace :deploy do
  task :start do; end
  task :stop do; end

  desc "Touch restart.txt to tell passenger to restart"
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

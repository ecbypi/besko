# dependencies
require 'bundler/capistrano'
require 'pathname'

# honeybadger configuration/tasks
require './config/boot'
require 'honeybadger/capistrano'

set :stages, %w( production staging )
set :default_stage, 'staging'

require 'capistrano/ext/multistage'

# Server(s) deploying to
set :application, 'besko'
server 'besko.mit.edu', :web, :app, :db, primary: true

# Repository information
set :scm, :git
set :scm_username, 'git'
set :repository, 'git@github.com:ecbypi/besko.git'
set :branch, 'master'
set :deploy_via, :remote_cache

# Environment settings
set :user, 'deploy'
set :use_sudo, false
set :migrate_target, :current
set :rails_env, 'production'
set :deploy_to, '/var/www/besko'

# Use custom ruby-build path for ruby
set :default_environment, {
  'PATH' => '/usr/local/ruby/bin:$PATH'
}

# For custom symlinks tasks to manage all symlinks in one task
set :normal_symlinks, %w(
  config/newrelic.yml
  config/database.yml
  config/initializers/secret_token.rb
  log
)

set :odd_symlinks, {
  'sockets' => 'tmp/sockets',
  'pids' => 'tmp/pids',
  'assets' => 'public/assets',
  'system' => 'public/system'
}

# Don't touch old asset directories (/public)
set :normalize_assets_timestamps, false
set :shared_children, []

namespace :deploy do
  task :start do; end
  task :stop do; end

  desc "Touch restart.txt to tell passenger to restart"
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Make default symlink tasks a no-op
  task :symlink do ; end

  # Create all symlinks in one tas
  desc "Symlink everything in one task"
  task :make_symlinks, :roles => :web, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path, release_path]
    dirs += normal_symlinks.map { |d| Pathname.new(File.join(shared_path, d)).dirname }
    dirs += odd_symlinks.map { |from, to| File.join(shared_path, from) }

    commands = normal_symlinks.map do |path|
      "rm -rf #{release_path}/#{path} && \
       ln -s #{shared_path}/#{path} #{release_path}/#{path}"
    end

    commands += odd_symlinks.map do |from, to|
      "rm -rf #{release_path}/#{to} && \
      ln -s #{shared_path}/#{from} #{release_path}/#{to}"
    end

    run <<-CMD
      mkdir -p #{release_path}/tmp &&
      mkdir -p #{dirs.join(' ')} &&
      #{commands.join(' && ')}
    CMD
  end

  # Task to seed the database
  namespace :db do
    desc "Setup database"
    task :setup do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:setup"
    end
  end

  namespace :assets do
    desc "Precompile assets only if they don't exist or have been updated"
    task :precompile, :roles => :web, :except => { :no_release => true } do
      revision_path = current_path + '/REVISION'
      command = "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"

      deployed_revision = capture("if [ -f #{revision_path} ]; then cat #{revision_path}; fi").strip

      if deployed_revision.empty?
        run command
      else
        diff = capture("cd #{shared_path}/cached-copy; git diff #{deployed_revision} app/assets").strip
        files = capture("ls #{current_path}/public/assets").strip

        if !diff.empty? || files.empty?
          run command
        end
      end
    end
  end
end

# Make all symlinks after updating code
after "deploy:update_code", "deploy:make_symlinks"

# disable/enable the site when migrating
before "deploy:migrate", "deploy:web:disable"
after "deploy:migrate", "deploy:web:enable"

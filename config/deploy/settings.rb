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

set :shared_children, []

# Server(s) deploying to
set :application, 'besko'
server 'besko.mit.edu', :web, :app, :db, primary: true

# Repository information
set :scm, :git
set :scm_username, 'git'
set :repository, 'git@github.com:ecbypi/besko.git'
set :branch, 'origin/master'

# Environment settings
set :user, 'passenger'
set :use_sudo, false
set :migrate_target, :current
set :rails_env, 'production'
set :deploy_to, '/var/lib/passenger/besko'

# Use custom ruby-build path for ruby
set :default_environment, {
  'PATH' => '/usr/local/ruby/bin:$PATH'
}

set :shared_children, %w(public/system log tmp/pids tmp/sockets private)

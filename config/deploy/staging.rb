set :deploy_to, '/var/www/besko-staging'
set :rails_env, 'staging'
set :branch do
  `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//,'')
end

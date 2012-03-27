set :normal_symlinks, %w(
  config/database.yml
  private
  log
)

set :odd_symlinks, {
  'sockets' => 'tmp/sockets',
  'pids' => 'tmp/pids',
  'assets' => 'public/assets',
  'system' => 'public/system'
}

namespace :deploy do
  task :create_symlink do ; end
  task :symlink do ; end

  desc "Symlink everything in one task"
  task :make_symlinks, :roles => :web, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path, release_path]
    dirs += normal_symlinks.map { |d| File.join(shared_path, d.split('/').first) }
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
      mkdir -p #{current_path}/tmp &&
      mkdir -p #{dirs.join(' ')} &&
      #{commands.join(' && ')}
    CMD
  end
end

after "deploy:update_code", "deploy:make_symlinks"

load 'deploy/assets'

# Don't touch old asset directories (/public)
set :normalize_assets_timestamps, false

namespace :deploy do
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

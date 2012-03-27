load 'deploy/assets'

# Don't touch old asset directories (/public)
set :normalize_assets_timestamps, false

namespace :deploy do
  namespace :assets do
    desc "Precompile assets only if they don't exist or have been updated"
    task :precompile, roles: :web, except: { no_release: true } do
      deployed_revision = capture("cat #{current_path}/REVISION").strip
      diff = capture("cd #{current_path}; git diff #{deployed_revision} app/assets").strip
      files = capture("ls #{current_path}/public/assets").strip
      if !diff.empty? || files.empty?
        run("cd #{latest_release} &&
            #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
           )
      end
    end
  end
end

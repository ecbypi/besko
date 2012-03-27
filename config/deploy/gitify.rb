# These settings are for using the :current_dir directory and fetching differences
# instead of doing a full clone each deploy

# More meangingful release directory
set :current_dir, 'release'

# All paths should be current path
set(:lastest_release) { fetch(:current_path) }
set(:release_path) { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

# Grab revisions from current path
set(:current_revision) { capture("cd #{current_path}; git rev-parse HEAD").strip }
set(:latest_revision) { capture("cd #{current_path}; git rev-parse HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse HEAD@{1}").strip }

# We don't need a releases directory
set(:releases_path) { fetch(:current_path) }

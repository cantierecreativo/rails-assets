set :deploy_to, '/srv/gmd/staging'
set :rails_env, 'staging'
set :branch, ENV.fetch('branch', 'staging')

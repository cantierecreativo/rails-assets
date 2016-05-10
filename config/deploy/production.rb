set :deploy_to, '/srv/rails_assets/production'
set :rails_env, 'production'
set :branch, ENV.fetch('branch', 'master')

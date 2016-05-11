# coding: utf-8
require 'capistrano-db-tasks'

lock '3.4.0'

hostname = ENV.fetch("DEPLOY_HOSTNAME", "")

local_path = File.dirname(File.expand_path(File.join(__FILE__, '..')))

server hostname,
       user: 'deploy',
       roles: %i(web app db),
       primary: true,
       port: 54321

set :application, 'gmd'
set :repo_url, 'https://github.com/cantierecreativo/rails-assets.git'
set :scm, :git
set :bundle_flags, "--deployment --quiet"
set :bundle_without, %w{development test}.join(' ')

set :default_env, { path: "/opt/rbenv/shims:/opt/rbenv/bin:$PATH" }
set :rbenv_ruby, '2.2.3'
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn", "#{fetch(:rails_env)}.rb") }

set :pg_password, ENV.fetch("PGPASSWORD", nil)

set :linked_files, %w{
  .env
  config/database.yml
}

set :linked_dirs, %w{
  tmp/pids
  tmp/cache
  tmp/sockets
  log
  public/system
  public/assets
}


set :ssh_options, { forward_agent: true }

set :keep_releases, 10

set :disallow_pushing, true

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart_unicorn do
    invoke "unicorn:stop"
    invoke "unicorn:start"
  end
  after :publishing, 'deploy:restart_unicorn'

  desc "Invoke rake task"
  task :invoke do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end

  desc "Tail rails log"
  task :logs do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end

  desc "Tail unicorn log"
  task :unicorn_logs do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/unicorn.log"
    end
  end
end

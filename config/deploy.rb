# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"


set :application, "schedude"
set :repo_url, "git@github.com:GondaKid/schedude.git"

set :pty, true
set :linked_files, %w(config/database.yml config/application.yml config/master.key )
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle bundle public/system public/uploads node_modules)
set :keep_releases, 2

# rbenv setup
set :rbenv_type, :user 
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_map_bins, %w(rake gem bundle ruby rails puma pumactl)

# puma setup
set :puma_rackup, -> {File.join(current_path, "config.ru")}
set :puma_state, -> {"#{shared_path}/tmp/pids/puma.state"}
set :puma_pid, -> {"#{shared_path}/tmp/pids/puma.pid"}
set :puma_bind, -> {"unix://#{shared_path}/tmp/sockets/puma.sock"}
set :puma_conf, -> {"#{shared_path}/puma.rb"}
set :puma_access_log, -> {"#{shared_path}/log/puma_access.log"}
set :puma_error_log, -> {"#{shared_path}/log/puma_error.log"}
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, "production"))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
set :puma_plugins, [:tmp_restart]

# asset setup
set :assets_roles, [:web, :app]
set :assets_prefix, 'prepackaged-assets'
set :assets_manifests, ['app/assets/config/manifest.js']
set :rails_assets_groups, :assets
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :keep_assets, 2

# tasks setup
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
    
  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      invoke 'deploy'
    end
  end

  after :finishing, :cleanup
  before :reverted, 'npm:install'
end






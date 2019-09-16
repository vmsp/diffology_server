# config valid for current version and patch releases of Capistrano
lock "~> 3.11.1"

set :application, "diffology"
set :repo_url, "git@github.com:vmsp/diffology_server.git"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/diffology"

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, ".bundle", "log", "tmp/pids", "tmp/cache", "tmp/sockets"

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Rails
set :rails_env, "production"
set :migration_role, :app

# Bundler
set :bundle_jobs, 1

# File Permissions
set :file_permissions_paths, %w(log tmp/pids tmp/cache tmp/sockets)
set :file_permissions_users, %w(www-data)

before "deploy:updated", "deploy:set_permissions:acl"

# Custom Tasks
namespace :deploy do
  desc "Restart Puma"
  task :restart_puma do
    on roles(:app) do
      execute "systemctl reload-or-restart puma.service"
    end
  end

  desc "Restart Nginx"
  task :restart_puma do
    on roles(:app) do
      execute "systemctl reload-or-restart nginx"
    end
  end
end

# after "deploy:publishing", "deploy:restart_puma"

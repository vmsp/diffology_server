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
append :linked_dirs, ".bundle", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/plugin"

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

# "setfacl: /.../...: Operation not permitted" errors are fine. The referenced
# files were already created by www-data and are, obviously, accessible by it.
before "deploy:updated", "deploy:set_permissions:acl"

# SystemD
namespace :deploy do
  desc "Stop Puma"
  task :stop_puma do
    on roles(:app) do
      execute "sudo systemctl stop puma.service"
    end
  end

  desc "Start Puma"
  task :start_puma do
    on roles(:app) do
      execute "sudo systemctl start puma.service"
    end
  end
end

before "deploy:updated", "deploy:stop_puma"
after "deploy:finished", "deploy:start_puma"

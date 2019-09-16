# config valid for current version and patch releases of Capistrano
lock "~> 3.11.1"

set :application, "diffology"
set :repo_url, "https://github.com/vmsp/diffology_server.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/diffology"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, ".bundle", "log", "tmp/pids", "tmp/cache", "tmp/sockets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Rails
set :rails_env, "production"
set :migration_role, :app

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

after "deploy:publishing", "deploy:restart_puma"

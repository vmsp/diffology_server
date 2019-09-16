app_dir = File.expand_path("../../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

threads 1, 4
directory app_dir
environment "development"
pidfile "#{tmp_dir}/pids/puma.pid"
# Puma can't store unix sockets on virtualbox shared folders.
# bind "unix://#{tmp_dir}/sockets/puma.sock"
bind "unix:///tmp/puma.sock"
plugin :tmp_restart

app_dir = File.expand_path("../../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
max_threads = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads = ENV.fetch("RAILS_MIN_THREADS") { max_threads }
threads min_threads, max_threads

directory app_dir
environment "production"
pidfile "#{tmp_dir}/pids/puma.pid"
bind "unix://#{tmp_dir}/sockets/puma.sock"

preload_app!

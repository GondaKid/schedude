
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count
port        ENV.fetch("PORT") { 3000 }

# server puma setting
environment "production"
app_dir = File.expand_path("../..", __FILE__)

# Set up socket location
bind "unix:///home/deploy/apps/schedude/shared/tmp/sockets/puma.sock"

# Logging
stdout_redirect "/home/deploy/apps/schedude/shared/log/puma.stdout.log", "/home/deploy/apps/schedude/shared/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "/home/deploy/apps/schedude/shared/tmp/pids/puma.pid"
state_path "/home/deploy/apps/schedude/shared/tmp/pids/puma.state"
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

plugin :tmp_restart


# # Specifies the `environment` that Puma will run in.
# #s
# environment ENV.fetch("RAILS_ENV") { "development" }

# # Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
# plugin :tmp_restart

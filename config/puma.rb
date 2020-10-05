
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count
port        ENV.fetch("PORT") { 3000 }

# # Specifies the `environment` that Puma will run in.
# #
# environment ENV.fetch("RAILS_ENV") { "development" }

# # Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
# plugin :tmp_restart

# server puma setting
environment "production"
shared_dir = ""
app_dir = File.expand_path("../..", __FILE__)

# Set up socket location
bind "unix:///deploy/apps/schedude/shared/tmp/sockets/puma.sock"

# Logging
stdout_redirect "/deploy/apps/schedude/shared/log/puma.stdout.log", "/deploy/apps/schedude/shared/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "/deploy/apps/schedude/shared/tmp/pids/puma.pid"
state_path "/deploy/apps/schedude/shared/tmp/pids/puma.state"
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
activate_control_app
plugin :tmp_restart

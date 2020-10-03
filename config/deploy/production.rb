set :stage, :production
set :rails_env, :production
set :deploy_to, "/deploy/apps/schedude"
set :branch, "master"
server "52.203.239.10", user: "deploy", roles: %w(web app db)
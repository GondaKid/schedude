set :stage, :production
set :rails_env, :production
set :deploy_to, "/home/deploy/apps/schedude/"
set :branch, "deploy"

server "schedude.me", user: "deploy", roles: %w(web app db), primary: true
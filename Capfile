require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/rbenv"
require "capistrano/puma"
install_plugin Capistrano::Puma

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/bundler"
require "capistrano/rails/migrations"
# require "capistrano/yarn"
require "capistrano/rails/assets"


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

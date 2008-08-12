set :application, "regional"
set :repository,  "ssh://#{STDIN.gets.chomp}@repos.kakutani.com/var/cache/git/regional_rubykaigi"
set :branch, "master"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/#{application}/railsapp"
set :ssh_options, { :forward_agent => true }

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :git_shallow_clone, 1

set :use_sudo, false
set :runner, "regional"
ssh_options[:username] = application

set :production_server, "alpha.kakutani.com"
role :app, production_server
role :web, production_server
role :db,  production_server, :primary => true

set :rake, "/home/#{application}/gem.repos/bin/rake"

namespace :deploy do
#  task :after_update_code do
#    db_path = "db/production.sqlite3"
#    shared_db_path = "#{shared_path}/#{db_path}"
#    dest_db_path = "#{release_path}/#{db_path}"
#    run "! test -e #{dest_db_path} && ln -s #{shared_db_path} #{dest_db_path}"
#  end

  desc "resart for our application"
  task :restart, :roles => :app, :except => { :no_release => true } do |t|
    stop
    start
  end
end

# -*- coding: utf-8 -*-
set :application, "regional"
set :repository,  "git://github.com/kakutani/regional_rubykaigi.git"
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

set :production_server, "regional.rubykaigi.org"
role :app, production_server
role :web, production_server
role :db,  production_server, :primary => true

set :rake, "/home/#{application}/bin/rake"

def setup_shared(dir, path)
  src = "#{shared_path}/#{dir}/#{path}"
  dest = "#{latest_release}/#{dir}/#{path}"
  run "! test -e #{dest} && ln -s #{src} #{dest}"
end

def setup_shared_config(path)
  setup_shared("config", path)
end

require 'net/http'
require 'uri'
def notify_irc_cat
  task_name = ARGV.shift.chomp
  message = "[regional.rubykaigi.org] cap #{task_name} => done"
  Net::HTTP.version_1_1
  Net::HTTP.get_print 'alpha.kakutani.com', "/send/#{URI.escape(message)}", 3489
end

namespace :deploy do
  task :after_update_code do
    setup_shared("db", "production.sqlite3")
    setup_shared_config("config_action_controller_session.rb")
    setup_shared_config("initializers/site_keys.rb")
  end

  desc "resart for our application"
  task :restart, :roles => :app, :except => { :no_release => true } do |t|
    stop
    start
  end

  task :after_restart do
    notify_irc_cat
  end
end

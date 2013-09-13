require "bundler/capistrano"

server "112.124.48.51", :web, :app, :db, primary: true

set :application, "faxin"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:tomwey/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# 保留5个最新的版本
after "deploy", "deploy:cleanup"
# after "deploy:cleanup", "deploy:remote_rake"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
  
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
  
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  
  task :remote_rake, roles: :db do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  # desc "Make sure local git is in sync with remote."
  # task :check_revision, roles: :web do
  #   unless `git rev-parse HEAD` == `git rev-parse origin/master` do
  #     puts "WARNING: HEAD is not the same as origin/master"
  #     puts "Run `git push` to sync changes."
  #     exit
  #   end
  # end
  # before "deploy", "deploy:check_revision"
end

# 全文检索
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end

  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
  end

  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data/*"
    start
    run "cd #{current_path} && yes | RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

  desc "Symlink in-progress deployment to a shared Solr index"
  task :symlink, :except => { :no_release => true } do
    # run "ln -s #{shared_path}/solr/conf #{release_path}/solr/conf"
    run "ln -nfs #{shared_path}/solr #{release_path}/solr"
    # run "ln -s #{shared_path}/solr/pids/ #{release_path}/solr/pids"
  end
end

after "deploy:update_code", "solr:symlink"

#  
# after 'deploy:setup', 'deploy:setup_solr_data_dir'

namespace :remote_rake do
  task :invoke do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  task :drop do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:drop"
  end
end
# 
# namespace :my_tasks do
#   task :copy_to_public do
#     run "cp /home/#{user}/share_icon.png #{deploy_to}/current/public/share_icon.png"
#     run "cp -r /home/#{user}/share_link/ #{deploy_to}/current/public"
#   end
# end
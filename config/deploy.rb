require 'yaml'

require 'rvm/capistrano'
require 'bundler/capistrano'
set :application, 'moodkick-server-backend'
set :repository,  'git@translucent.beanstalkapp.com:/moodkick-server-backend.git'

set :rvm_type, :user
set :scm, :git

server = 'app.moodkick.com'
role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, primary: true           # This is where Rails migrations will run

set :branch, 'master'

set :user, 'rubyrunner'
set :deploy_to, "/home/rubyrunner/apps/#{application}"

set :use_sudo, false
set :keep_releases, 5

# if you want to clean up old releases on each deploy uncomment this:
# after 'deploy:restart', 'deploy:cleanup'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :backup_database do
  config_text = capture("cat #{deploy_to}/current/config/database.yml")
  config = YAML::load(config_text)['production']
  run "PGPASSWORD=#{config['password']} pg_dump #{config['database']} -U #{config['username']} | gzip > #{shared_path}/database_dumps/#{Time.now.getutc.strftime("%Y%m%d%H%M%S")}.sql.gz"
end
before 'deploy', 'backup_database'

task :symlink_database_yml do
 run "ln -sfn #{shared_path}/config/database.yml
      #{release_path}/config/database.yml"
end
after 'bundle:install', 'symlink_database_yml'

task :symlink_content_objects do
  run "ln -sfn #{shared_path}/content_objects #{release_path}/public/content_objects"
end
after 'bundle:install', 'symlink_content_objects'


after 'deploy', 'deploy:migrate'

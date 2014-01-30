require "bundler/capistrano"
#require 'thinking_sphinx/deploy/capistrano'
#require "capistrano-resque"

# estudiar esto, peta al hacer el deploy
# apardo 20130221
#require './config/boot'
#require 'airbrake/capistrano'

set :scm,             :git
set :repository,      "git@github.com:alabs/oigame.git"
set :branch,          "origin/master"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }
set :rails_env,       "production"
set :deploy_to,       "/var/www/oiga.me"
set :normalize_asset_timestamps, false

set :user,            "oigame"
set :group,           "oigame"
set :use_sudo,        false

role :web,    "polar.oiga.me"
role :app,    "polar.oiga.me"
role :db,     "polar.oiga.me", :primary => true

#role :resque_worker, "polar.oiga.me"
#role :resque_scheduler, "polar.oiga.me"

# set :workers, { "archive" => 1, "mailing" => 3, "search_index, cache_warming" => 1 } el número de workers
#set :workers, { "mailer" => 1, "fax" => 1 }

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

default_environment["RAILS_ENV"] = 'production'

# Use our ruby-1.9.3-p194@oigame
default_environment["PATH"]         = "/home/oigame/.rvm/gems/ruby-1.9.3-p392@oigame/bin:/home/oigame/.rvm/gems/ruby-1.9.3-p392@global/bin:/home/oigame/.rvm/rubies/ruby-1.9.3-p392/bin:/home/oigame/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
default_environment["GEM_HOME"]     = "/home/oigame/.rvm/gems/ruby-1.9.3-p392@oigame"
default_environment["GEM_PATH"]     = "/home/oigame/.rvm/gems/ruby-1.9.3-p392@oigame:/home/oigame/.rvm/gems/ruby-1.9.3-p392@global"
default_environment["RUBY_VERSION"] = "ruby-1.9.3-p392"

default_run_options[:shell] = 'bash'
default_run_options[:pty] = true

namespace :deploy do
  desc "Deploy your application"
  task :default do
    update
    restart
  end

  desc "Setup your git-based deployment app"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
    restart_resque
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -sf #{shared_path}/log #{latest_release}/log &&
      ln -sf #{shared_path}/system #{latest_release}/public/system &&
      ln -sf #{shared_path}/pids #{latest_release}/tmp/pids &&
      ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml &&
      ln -sf #{shared_path}/uploads #{latest_release}/public &&
      ln -sf #{shared_path}/config/app_config.yml #{latest_release}/config/app_config.yml &&
      ln -sf #{shared_path}/config/newrelic.yml #{latest_release}/config/newrelic.yml &&
      ln -sf #{shared_path}/public/sitemap1.xml.gz #{latest_release}/public/sitemap1.xml.gz &&
      ln -sf #{shared_path}/public/sitemap_index.xml.gz #{latest_release}/public/sitemap_index.xml.gz &&
      ln -sf #{shared_path}/config/recaptcha.rb #{latest_release}/config/initializers/recaptcha.rb
      ln -sf #{shared_path}/config/airbrake.rb #{latest_release}/config/initializers/airbrake.rb
    CMD

    #if fetch(:normalize_asset_timestamps, true)
    #  stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
    #  asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
    #  run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    #end

    # compilar en local y subir los assets al repo
    # precompile assets
    #run "cd #{latest_release}; RAILS_ENV=staging bundle exec rake assets:precompile"
  end

  desc "Restart resque workers"
  task :restart_resque, :except => { :no_release => true } do
    run <<-CMD
      sudo /etc/init.d/oiga.me.resque stop &&
      sudo /etc/init.d/oiga.me.resque start
    CMD
  end

  #namespace :assets do
  #  task :precompile, :roles => :web, :except => { :no_release => true } do
  #    from = source.next_revision(current_revision)
  #    if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
  #      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #    else
  #      logger.info "Skipping asset pre-compilation because there were no asset changes"
  #    end
  #  end
  #end
  
  #namespace :assets do

  #  #task :precompile, :roles => :web do
  #  #  from = source.next_revision(current_revision)
  #  #  if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ | wc -l").to_i > 0
  #  #    run_locally("rake assets:clean && rake assets:precompile")
  #  #    run_locally "cd public && tar -jcf assets.tar.bz2 assets"
  #  #    top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
  #  #    run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
  #  #    run_locally "rm public/assets.tar.bz2"
  #  #    run_locally("rake assets:clean")
  #  #  else
  #  #    logger.info "Skipping asset precompilation because there were no asset changes"
  #  #  end
  #  #end
  #  
  #  task :symlink, roles: :web do
  #    run ("rm -rf #{latest_release}/public/assets &&
  #          mkdir -p #{latest_release}/public &&
  #          mkdir -p #{shared_path}/assets &&
  #          ln -s #{shared_path}/assets #{latest_release}/public/assets")
  #  end
  #end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /var/www/oiga.me/current; bundle exec thin restart --onebyone --wait 30 -C config/thin_production.yml
    CMD
  end

  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /var/www/oiga.me/current; bundle exec thin start -C config/thin_production.yml
    CMD
  end
  
  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /var/www/oiga.me/current; bundle exec thin stop -C config/thin_production.yml
    CMD
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end
    
task :compile_assets do
  run "cd #{release_path}; bundle exec rake assets:precompile"
end


def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end

#before 'deploy:update_code', 'thinking_sphinx:stop'
#after 'deploy:update_code', 'thinking_sphinx:start'
#
#namespace :sphinx do
#  desc "Symlink Sphinx indexes"
#  task :symlink_indexes, :roles => [:app] do
#    run "ln -nfs #{shared_path}/db/sphinx_production #{release_path}/db/sphinx"
#  end
#end

#after 'deploy:finalize_update', 'sphinx:symlink_indexes'

#after 'deploy:finalize_update', 'compile_assets'
before 'deploy:finalize_update', 'deploy:assets:symlink'
#after 'deploy:update_code', 'deploy:assets:precompile'
#after "deploy:restart", "resque:restart"

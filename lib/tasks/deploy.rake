


namespace :deploy do
  def production_app_name
    "sharp-sunset-8021"
  end

  def alert(msg)
    puts "== #{msg}"
  end

  def notify_campfire(msg)

  end

  desc "deploys to production in a standard way"
  task :production => :environment do
    alert "Preparing to deploy"
    Rake::Task["deploy:sync_master"].invoke
    result = Rake::Task["deploy:test"].invoke
    alert result
    if result.blank?
      alert 'fix your tests before deploying kthnks bye'
    else
      notify_campfire 'Hold onto your Butts: Deploying to Production, all tests passing'
      Rake::Task["deploy:heroku:deploy_production"]
      Rake::Task["deploy:heroku:migrate_production"]
    end
  end

  namespace :heroku do
    desc 'deploys directly to heroku production'
    task :deploy_production => :environment do
      alert 'Starting Deploy!'
      %x{ git push git@heroku.com:#{production_app_name}.git }
    end

    desc 'migrates the production database'
    task :migrate_production => :environment do
      alert 'migrating databse...just incase'
      %x{ heroku db:migrate --app #{production_app_name}}
    end
  end

  desc "pulls then pushes to master"
  task :test => :environment do
    alert "running tests"
    result = system %q{ git_test push }
    return result
  end

  task :prepare_test => :environment do
    alert "preparing test database"
    %x{ rake db:test:load }
  end

  desc "pulls then pushes to master"
  task :sync_master => :environment do
    alert "syncing with github"
    %x{ git pull origin master }
    %x{ git push origin master }
  end
end

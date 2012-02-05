


namespace :deploy do
  def production_app_name
    "hourschool"
  end

  def alert(msg)
    puts "== #{msg}"
  end

  def notify_campfire(msg)

  end

  desc "deploys to production in a standard way"
  task :production => :environment do
    alert "Preparing to deploy"
    Rake::Task["deploy:pull_master"].invoke
    Rake::Task["deploy:test"].invoke
    if ENV['test_result'].try(:downcase) == "true"
      notify_campfire 'Hold onto your Butts: Deploying to Production, all tests passing'
      Rake::Task["deploy:heroku:deploy_production"].invoke
      Rake::Task["deploy:heroku:migrate_production"].invoke
      notify_campfire 'Deploy done'
      alert 'All done, please manually check the website still exists'
    else
      alert 'fix your tests before deploying kthnks bye'
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
      puts %x{ heroku run rake db:migrate --app #{production_app_name} }
    end
  end

  desc "pulls then pushes to master"
  task :test => :environment do
    alert "running tests"
    result = system %q{ git_test push }
    ENV['test_result'] = result.to_s # true/false
  end

  task :prepare_test => :environment do
    alert "preparing test database"
    %x{ rake db:test:load }
  end

  desc "pulls master"
  task :pull_master => :environment do
    alert "Syncing with github"
    %x{ git pull origin master }
  end
end

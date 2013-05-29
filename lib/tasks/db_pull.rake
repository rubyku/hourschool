namespace :db do
  task :pull do
    app_name = "hourschool"
    puts "== capturing backup"
    `heroku pgbackups:capture --expire -a #{app_name}`
    url           = `heroku pgbackups:url -a #{app_name}`
    dump_location = '/tmp/backupdatabase.dump'
    db   = YAML.load_file('config/database.yml')['development']
    dbname = db['database']
    host   = db['host']
    puts "== downloading backup"
    puts "curl -o #{dump_location} '#{url}'"
    `curl -o #{dump_location} '#{url}'`
    puts "== loading backup into #{dbname}"
    puts "pg_restore --verbose --clean --no-acl --no-owner -h #{host}  -d #{dbname} #{dump_location}"
    `pg_restore --verbose --clean --no-acl --no-owner -h #{host}  -d #{dbname} #{dump_location}`
  end
end



namespace :develop do

  def check_solr_running!
    puts "Make sure not solr process is running"
    puts "==========="
    result =  %x{ps aux |grep solr | grep -v grep | grep -v  develop:fix:solr }.split(/(\s+)/)
    puts "==========="
    puts result.join(' ')
    if result.length > 4
      process_id = result[2]
      puts "
            Looks like solr is still running,
            please kill #{process_id} before continuing
            `kill -9 #{process_id}`
            you can do this in another tab"
      puts "\n press any key to continue"
      STDIN.gets
    end
  end

  namespace :fix do
    desc 'when solr is misbehaving locally this will reset it'
    task :solr => :environment do
      check_solr_running!
      %x{rm -rf solr/}
      Rake::Task["sunspot:solr:start"].invoke
    end
  end

end

# require 'iconv'
# ICONV = Iconv.new( 'UTF-8', 'ISO-8859-1' )

namespace :cities do
  desc "import from csv"
  task :import => :environment do
    City.delete_all

    CSV.foreach("#{Rails.root}/db/cities1000.csv", {:col_sep => "\t"}) do |row|
    	begin
        c = City.create(:name => (row[1]), :state => (row[10]), :population => row[14], :lat => row[4], :lng => row[5], :country_code => row[8], :time_zone => row[17])
        puts "#{c.id}: #{c.name} CREATED => #{c.inspect}"
      rescue
        puts $!.message
        $stdout.print 'f'
      end
    end
  end

  desc "update course ids with new city ids"
  task :copy_old_ids => :environment do
    ids = [
      ['Portland| OR', 98],
      ['Austin| TX', 17],
      ['Toronto| 08', 43],
      ['Austin| TX', 1],
      ['San Francisco| CA', 2],
      ['Windsor| CO', 66],
      ['Ann Arbor| MI', 58],
      ['Loveland| CO', 27],
      ['Visalia| CA', 197],
      ['Loveland| CO', 6],
      ['Lahore| 04', 103],
      ['Ann Arbor| MI', 118],
      ['Ann Arbor| MI', 125],
      ['Richmond| VA', 40],
      ['Mill Valley| CA', 84],
      ['Ann Arbor| MI', 59],
      ['Seattle| WA', 82],
      ['Los Angeles| CA', 50],
      ['Austin| TX', 8],
      ['Loveland| CO', 88],
      ['Santa Monica| CA', 62],
      ['New York City| NY', 65],
      ['Toronto| 08', 53],
      ['Ann Arbor| MI', 108],
      ['Ann Arbor| MI', 63],
      ['Toronto| 08', 83],
      ['Ann Arbor| MI', 134],
      ['Walled Lake| MI', 150],
      ['Warren| MI', 161],
      ['San Antonio| TX', 182],
      ['Carrollton| TX', 168],
      ['Saline| MI', 188],
      ['Ann Arbor| MI', 146],
      ['Ann Arbor| MI', 100],
      ['Washington, D. C.| DC', 209],
      ['Pasadena| CA', 170],
      ['Ann Arbor| MI', 196],
      ['Waterloo| 10', 44],
      ['Portland| OR', 99],
      ['Brighton| MI', 148],
      ['Worcester| MA', 9],
      ['Ann Arbor| MI', 127],
      ['Philadelphia| PA', 79],
      ['San Francisco| CA', 36],
      ['Baltimore| MD', 61],
      ['Berkeley| CA', 38],
      ['Ann Arbor| MI', 164]
    ]

    old_and_news = []
    ids.each do |id|
      city = City.where('name = ?', id[0].split('|')[0]).where('state = ?', id[0].split('|')[1].strip).first
      if city
        old_and_news << {:old => id[1], :new => city.id}
      else
        puts "no city! #{id.inspect}"
      end
    end
    old_and_news << {:old => 147, :new => City.find_by_population(528595).id}
    old_and_news << {:old => 175, :new => City.find_by_name('Boise').id}

    old_and_news.each do |o_a_n|
      Course.update_all({:city_id => o_a_n[:new]}, {:city_id => o_a_n[:old]})
    end

  end
end
class AddTimezoneToCities < ActiveRecord::Migration
  def change
    add_column :cities, :time_zone, :string
    City.reset_column_information
    City.all.each do |city|
      begin
        time_zone = Timezone::Zone.new(:latlon => [city.lat, city.lng]).zone
        city.update_attribute(:time_zone, time_zone)
        puts "City:#{city.id} #{city.name} in #{time_zone}"
      rescue
        puts "City:#{city.id} no time zone found for #{city.name}"
      end
    end
  end
end

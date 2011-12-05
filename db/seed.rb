puts 'CREATING users'


TAGS = ["Art, Design and Philosophy","Health and Wellness", "Language", "Maintainance", "Technology"]


(1..6).each do |count|
  name = "#{Random.firstname} #{Random.initial} #{Random.lastname}"
  email = "people_#{count}@test.com"
  password = "testing"
  if count < 2
    location = "78759"
  elsif count > 2 && count < 6
    location = "94110"
  else
    location = "48103"
  end
  user = User.create! :name => name, :email => email, :password => password, :password_confirmation => password, :zipcode => location
  user.save
  
  random_text = Random.paragraphs
  title = random_text.split(/\s+/)[0..3].join(' ')
  about = random_text
  description = random_text
  price = Forgery(:monetary).money :min => 5, :max => 20
  seats = rand(20)
  seats = 10 unless seats != 0
  date = Random.date(0..21)
  time = "9-11pm"
  place = random_text
  address = Random.address_line_1
  minimum = rand(5)
  minimum = 1 unless minimum < seats && minimum != 0
  #get random tags
  tags = []
  tags << TAGS[rand(8)] 
  course = Course.create! :title => title, :description => description, :price => price, :seats => seats, 
                  :date => date, :time_range => time, :place => address, :minimum => minimum
  course.category_list = tags.join(", ").to_s
  
  if course.save
    crole = Crole.find_by_course_id_and_user_id(course.id, user.id) 
    if crole.nil?
       crole = course.croles.create!(:attending => true, :role => 'teacher')
       user.croles << crole
       user.courses << course
       user.save
     end
     city = City.find_by_name(user.city)
     city.courses << course
     city.save
     
     p "created course #{course.title}, #{course.price}, by #{user.name}, in #{location}"
  end
  
  #create two suggestions per user
  random_text = Random.paragraphs(1)
  sugg_name = random_text.split(/\s+/)[0..2].join(' ')
  sugg_desc = random_text
  sugg_requested_by = user.id
  csugg = Csuggestion.create! :name => sugg_name, :description => sugg_desc, :requested_by => sugg_requested_by
  user.vote_for(csugg)
  city = City.find_by_name(user.city)
   city.csuggestions << csugg
   city.save
  #create courses randomly
end


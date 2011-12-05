puts 'CREATING users'


TAGS = ["Art, Design and Philosophy","Health and Wellness", "Language", "Maintainance", "Technology"]


6.times.each do |count|

  user = Factory.create(:user)
  tags = []
  tags << TAGS[rand(8)]
  course = Factory.create(:course)
  course.category_list = tags.join(", ").to_s

  if course.save
    role = Role.find_by_course_id_and_user_id(course.id, user.id)
    if role.nil?
       role = course.roles.create!(:attending => true, :role => 'teacher', :course => course, :user => user)
       user.save
     end
     city = City.find_by_name(user.city)
     city.courses << course
     city.save

     puts "  Created course: #{course.title}, #{course.price}, by #{user.name}, in #{user.location}"
  end


  #create two suggestions per user
  random_text = Random.paragraphs(1)
  sugg_name = random_text.split(/\s+/)[0..2].join(' ')
  sugg_desc = random_text
  sugg_requested_by = user.id
  csugg = Suggestion.create! :name => sugg_name, :description => sugg_desc, :requested_by => sugg_requested_by
  user.vote_for(csugg)
  city = City.find_by_name(user.city)
   city.suggestions << csugg
   city.save
end


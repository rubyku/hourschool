# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# require 'rubygems'
# require 'random_data'
# require 'forgery'

puts 'CREATING users'

# = form_for @course, :html => { :multipart => true } do |f|
#   / = f.error_messages
#   %p
#     = f.label :title
#     %br
#     = f.text_field :title
#   %p
#     = f.label :description
#     %br
#     = f.text_area :description
#   %p
#     = f.label :price
#     %br
#     = f.text_field :price
#   %p
#     = f.label :seats
#     %br
#     = f.text_field :seats
#   %p
#     = f.label :date
#     %br
#     = f.date_select :date
#   %p
#     = f.label :time
#     %br
#     = f.time_select :time
#   %p
#     = f.label "Address"
#     %br
#     = f.text_field :place
#   
#   %p
#     = f.label "Minimum students needed for the class to happen"
#     %br
#     = f.text_field :minimum
#   %p
#     = f.label :photo
#     %br
#     = f.file_field :photo
#   %p

 # @course = Course.new(params[:course])
 #  @user = current_user
 #  if @course.save
 #    @crole = Crole.find_by_course_id_and_user_id(@course.id, current_user.id) 
 #    if @crole.nil?
 #      @crole = @course.croles.create!(:attending => true, :role => 'teacher')
 #      @user.croles << @crole
 #      @user.courses << @course
 #      @user.save
 #    end
 #    redirect_to @course, :notice => "Successfully created course."
 #  else
 #    render :action => 'new'
 #  end

# user1 = User.create! :name => 'John Doe', :email => 'johndoe@test.com', :password => 'testing', :password_confirmation => 'testing', :location => "Austin"
# puts 'New user created: ' << user1.name
# user2 = User.create! :name => 'Jane Doe', :email => 'janedoe@test.com', :password => 'testing', :password_confirmation => 'testing', :location => "Austin"
# puts 'New user created: ' << user2.name

TAGS = ["Art, Design and Philosophy","Health and Wellness", "Language", "Maintainance", "Technology"]

# city1 = City.create! :name => "Austin", :state => "TX"
# city2 = City.create! :name => "San Francisco", :state => "CA"
# city1.save
# city2.save

#p "Created cities, Austin and SF"

(1..100).each do |count|
  name = "#{Random.firstname} #{Random.initial} #{Random.lastname}"
  email = "people_#{count}@test.com"
  password = "testing"
  if count < 50
    location = "78759"
  elsif count > 50 && count < 75
    location = "94110"
  else
    location = "48103"
  end
  user = User.create! :name => name, :email => email, :password => password, :password_confirmation => password, :zipcode => location
  user.save
  
  random_text = Random.paragraphs
  title = random_text.split(/\s+/)[0..3].join(' ')
  description = random_text
  price = Forgery(:monetary).money :min => 5, :max => 20
  seats = rand(20)
  seats = 10 unless seats != 0
  date = Random.date(0..21)
  time = "9-11pm"
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
     
     # begin
     #        INDEX.document("course_#{course.id}").add({:text => course.description, :cid => "course_#{course.id}", :title => course.title, :tags => course.categories.join(' ')})
     #      rescue
     #        p "Skipping.."
     #        
     #      end
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


# user1.save
# user2.save
# puts 'SETTING UP ENTERPRISE'
# ent1 = Enterprise.create! :area => 'Austin, Texas', :name => 'Austin Center for Design', :domain => 'austincenterfordesign'
# ent2 = Enterprise.create! :area => 'Austin, Texas', :name => 'Google', :domain => 'gmail'
# 
# puts 'SETTING UP  SUBDOMAINS/COMPANIES'
# subdomain1 = Subdomain.create! :name => 'austincenterfordesign'
# puts 'Created subdomain: ' << subdomain1.name
# subdomain2 = Subdomain.create! :name => 'gmail'
# puts 'Created subdomain: ' << subdomain2.name
# ent1.subdomain = subdomain1
# ent1.save
# ent2.subdomain = subdomain2
# ent2.save
# 
# (1..100).each do |count|
#   name = "#{Random.firstname} #{Random.initial} #{Random.lastname}"
#   if count < 50
#    email = "austin_#{count}@gmail.com"
#   else
#     email = "austin_#{count}@austincenterfordesign.com"
#   end
#   
#   password = "testing"
#   if count < 50
#     organization = "Google"
#   else
#     organization = "Austin Center for Design"
#   end
#   member = Member.create! :name => name, :email => email, :password => password, :password_confirmation => password, :organization => organization
#   member.save
#   
#   random_text = Random.paragraphs
#   title = random_text.split(/\s+/)[0..3].join(' ')
#   description = random_text
#   seats = rand(20)
#   seats = 10 unless seats != 0
#   date = Random.date(0..21)
#   time = Time.now.gmtime
#   address = Random.address_line_1
#   minimum = rand(5)
#   minimum = 1 unless minimum < seats && minimum != 0
#   #get random tags
#   tags = []
#   tags << TAGS[rand(4)] 
#   ecourse = Ecourse.create! :title => title, :description => description, :price => 0.0, :seats => seats, 
#                   :date => date, :time => time, :place => address, :minimum => minimum
#   ecourse.category_list = tags.join(", ").to_s
#   
#   if ecourse.save
#     erole = Erole.find_by_ecourse_id_and_member_id(ecourse.id, member.id) 
#     if erole.nil?
#        erole = ecourse.eroles.create!(:attending => true, :role => 'teacher')
#        member.eroles << erole
#        member.ecourses << ecourse
#        member.save
#      end
#      ent = Enterprise.find_or_create_by_name_and_domain(member.org, member.domain)
#      ent.ecourses << ecourse
#      ent.save
#      
#      # begin
#      #        INDEX.document("course_#{course.id}").add({:text => course.description, :cid => "course_#{course.id}", :title => course.title, :tags => course.categories.join(' ')})
#      #      rescue
#      #        p "Skipping.."
#      #        
#      #      end
#      p "created course #{ecourse.title}, #{ecourse.price}, by #{member.name}, in #{organization}"
#   end
#   
#   #create two suggestions per user
#   random_text = Random.paragraphs(1)
#   sugg_name = random_text.split(/\s+/)[0..2].join(' ')
#   sugg_desc = random_text
#   sugg_requested_by = member.id
#   esugg = Esuggestion.create! :name => sugg_name, :description => sugg_desc, :requested_by => sugg_requested_by
#   member.vote_for(esugg)
#   ent = Enterprise.find_or_create_by_name_and_domain(member.org, member.domain)
#    ent.esuggestions << esugg
#    ent.save
#   #create courses randomly
# end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts 'CREATING users'

user1 = User.create! :name => 'John Doe', :email => 'johndoe@test.com', :password => 'testing', :password_confirmation => 'testing'
puts 'New user created: ' << user1.name
user2 = User.create! :name => 'Jane Doe', :email => 'janedoe@test.com', :password => 'testing', :password_confirmation => 'testing'
puts 'New user created: ' << user2.name
user1.save
user2.save

puts 'CREATING members'
member1 = Member.create! :name => 'Saran Vigraham', :email => 'saranyan.vigraham@ac4d.com', :password => 'testing',:password_confirmation => 'testing', :organizaiton => 'ac4d'
member1.save
puts "New member created"
member2 = Member.create! :name => 'Vigraham Saran', :email => 'svigraham@gmail.com', :password => 'testing',:password_confirmation => 'testing', :organizaiton => 'ac4d'
member2.save
puts "New member created"

puts 'SETTING UP ENTERPRISE'
ent1 = Enterprise.create! :area => 'Austin, Texas', :name => 'Austin Center for Design', :domain => 'ac4d'
ent2 = Enterprise.create! :area => 'Austin, Texas', :name => 'Google', :domain => 'gmail'

puts 'SETTING UP  SUBDOMAINS/COMPANIES'
subdomain1 = Subdomain.create! :name => 'ac4d'
puts 'Created subdomain: ' << subdomain1.name
subdomain2 = Subdomain.create! :name => 'gmail'
puts 'Created subdomain: ' << subdomain2.name
ent1.subdomain = subdomain1
ent1.save
ent2.subdomain = subdomain2
ent2.save
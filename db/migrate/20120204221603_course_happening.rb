class CourseHappening < ActiveRecord::Migration
  def up
    add_column :courses, :happening, :boolean, :default => false
    add_column :courses, :featured,  :boolean, :default => false
    add_index  :courses, :featured
    ## add happening? to courses
    Course.find_each do |course|
      course.update_attributes :happening => true if course.students.count >= (course.min_seats||0)
    end

    ## add featured? to courses
    Course.where(:id => [308, 244, 240, 237]).each do |course|
      course.update_attributes :featured => true
    end
  end

  def down
    remove_column :courses, :happening
    remove_column :courses, :featured
  end
end

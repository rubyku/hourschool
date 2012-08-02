class CreateCoursesTopicsJoinTable < ActiveRecord::Migration
  def change
    create_table :courses_topics, :id => false do |t|
      t.references :course, :topic
    end

    add_index :courses_topics, [:course_id, :topic_id]
  end
end

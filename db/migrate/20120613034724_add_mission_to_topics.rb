class AddMissionToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :mission, :references

  end
end

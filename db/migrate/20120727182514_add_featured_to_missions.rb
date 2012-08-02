class AddFeaturedToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :featured, :boolean, :default => false

  end
end

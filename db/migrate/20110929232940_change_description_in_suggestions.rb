class ChangeDescriptionInSuggestions < ActiveRecord::Migration
  def self.up
   change_column :esuggestions, :description, :text
   change_column :csuggestions, :description, :text
  end

  def self.down
   change_column :esuggestions, :description, :string
   change_column :csuggestions, :description, :text
  end
end

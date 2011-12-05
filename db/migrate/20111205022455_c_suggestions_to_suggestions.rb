class CSuggestionsToSuggestions < ActiveRecord::Migration
  def self.up
    rename_table :csuggestions, :suggestions
  end

  def self.down
    rename_table :suggestions, :csuggestions
  end
end

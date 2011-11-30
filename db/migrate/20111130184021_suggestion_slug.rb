class SuggestionSlug < ActiveRecord::Migration

  def self.tables
    [:users, :csuggestions, :courses]
  end


  def self.up
    tables.each do |table|
      add_column  table, :slug, :string
      add_index   table, :slug, :unique => true
    end
  end

  def self.down
    tables.each do |table|
      remove_index  table, :slug
      remove_column table, :slug
    end
  end
end

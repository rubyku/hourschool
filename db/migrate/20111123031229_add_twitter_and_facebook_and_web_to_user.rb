class AddTwitterAndFacebookAndWebToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :web, :string
  end

  def self.down
    remove_column :users, :web
    remove_column :users, :facebook
    remove_column :users, :twitter
  end
end

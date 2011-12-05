class RenameUserFields < ActiveRecord::Migration
  def self.user_fields_before_to_after
    {
      :about => :bio
     }
  end
  
  def self.up
    user_fields_before_to_after.each do |from, to|
      rename_column :users, from, to
    end
    add_column :users, :legacy_password_hash, :string
    add_column :users, :legacy_password_salt, :string
  end

  def self.down
    user_fields_before_to_after.each do |from, to|
      rename_column :users, to, from
    end
    remove_column :users, :legacy_password_hash, :string
    remove_column :users, :legacy_password_salt, :string
  end
end

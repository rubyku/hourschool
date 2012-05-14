class AddAttachmentPhotoToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :photo_file_name, :string
    add_column :accounts, :photo_content_type, :string
    add_column :accounts, :photo_file_size, :integer
    add_column :accounts, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :accounts, :photo_file_name
    remove_column :accounts, :photo_content_type
    remove_column :accounts, :photo_file_size
    remove_column :accounts, :photo_updated_at
  end
end

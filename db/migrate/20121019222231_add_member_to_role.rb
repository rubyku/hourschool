class AddMemberToRole < ActiveRecord::Migration
  def change
    add_column :roles, :member, :boolean

  end
end

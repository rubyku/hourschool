class AddInviterRoleIdToRole < ActiveRecord::Migration
  def change
    add_column :roles, :inviter_role_id, :integer
  end
end

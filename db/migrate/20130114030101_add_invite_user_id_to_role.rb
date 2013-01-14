class AddInviteUserIdToRole < ActiveRecord::Migration
  def change
    remove_column :roles, :inviter_role_id
    add_column  :roles, :invite_user_id, :integer
  end
end

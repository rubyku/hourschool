class AddEnterpriseIdToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :enterprise_id, :integer
    add_index :members, :enterprise_id
  end

  def self.down
    remove_column :members, :enterprise_id
  end
end

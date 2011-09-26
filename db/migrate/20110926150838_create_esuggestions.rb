class CreateEsuggestions < ActiveRecord::Migration
  def self.up
    create_table :esuggestions do |t|
      t.string :name
      t.string :description
      t.references :enterprise

      t.timestamps
    end
  end

  def self.down
    drop_table :esuggestions
  end
end

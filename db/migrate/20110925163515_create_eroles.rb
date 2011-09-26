class CreateEroles < ActiveRecord::Migration
  def self.up
    create_table :eroles do |t|
      t.references :member
      t.references :ecourse

      t.timestamps
    end
  end

  def self.down
    drop_table :eroles
  end
end

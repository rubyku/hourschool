class CreateCroles < ActiveRecord::Migration
  def self.up
    create_table :croles do |t|
      t.references :user
      t.references :course

      t.timestamps
    end
  end

  def self.down
    drop_table :croles
  end
end

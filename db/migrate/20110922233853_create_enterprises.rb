class CreateEnterprises < ActiveRecord::Migration
  def self.up
    create_table :enterprises do |t|
      t.string :area

      t.timestamps
    end
  end

  def self.down
    drop_table :enterprises
  end
end

class AddScheduleToSeries < ActiveRecord::Migration
  def change
    add_column :series, :schedule_hash, :text
    add_column :series, :publish_days_before, :integer
  end
end

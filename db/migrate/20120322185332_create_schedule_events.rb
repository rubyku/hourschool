class CreateScheduleEvents < ActiveRecord::Migration
  def change
    create_table :schedule_events do |t|
      t.integer     :series_id
      t.date        :publish_on
      t.datetime    :starts_at
      t.boolean     :published
      t.timestamps
    end
  end
end

Why its so great.


5:45

~40 some veg 1/8th


6pm 1616 Guadalupe Rm: 1.208 



Plan
----

Series.where(:course_id => 1).scheduler.schedule_events  # Course.series.scheduler.schedule_events
ScheduleEvent.scheduler.series.course

:scheduler
  :interval            (string)   [:weekly, :monthly]
  :repeat_on           (string)
  :start_on            (date)
  :start_at            (datetime)
  :ends_at             (datetime)
  :timezone            (string)
  :resource_name       (string)
  :resource_id         (int)        [Required]
  :publish_days_before (int)

:schedule_event
  :scheduler_id   (int)             [Required]
  :starts_at      (datetime)
  :publish_on     (date)            [Required]
  :publish        (boolean)



Every day pull all event_schedules with that go_live


## Needed

:weekly
  :repeat_every => 1,
  :repeat_on    => [:sunday,
                    :monday,
                    :tuesday,
                    :wednesday,
                    :thursday,
                    :friday,
                    :saturday],
  :start_on     => 3.days.from_now,
  :ends         => [nil, 3.times, 4.days.from_now_]


:monthly
  :repeat_every => 1,
  :repeat_on    => [:sunday,
                    :monday,
                    :tuesday,
                    :wednesday,
                    :thursday,
                    :friday,
                    :saturday],
  :start_on     => 3.days.from_now,
  :ends         => [:never, 3.times, 4.days.from_now_]


:repeats_for # number number of times

repeats_for.times do
  date    = DateTime.parse(params[:date])
  go_live = params[:go_live] || date - 2.weeks
  SeriesSchedule.new(date: date, go_live: go_live, time: params[:time], series_id: params[:series_id] )
end

schedules = SeriesSchedule.where('DATE(go_live) = DATE(?)', Time.now )
schedules.each do |schedule|
  last_course = schedule.series.course.last
  Course
end



:every 3rd tuesday
:every day
:every :week

:weekly :repeats_for => 3


:last tuesday
:first tuesday
:every :other tuesday
:every wednesday & friday

:specific, Jan 3rd
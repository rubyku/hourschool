module SeriesHelper
  def checked_for_series_if(series, day)
    check_day = Time.now.next_week(day).in_time_zone.utc
    series.schedule.occurs_on?(check_day)
  end
end

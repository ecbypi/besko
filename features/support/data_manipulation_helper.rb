module DataManipulationHelper
  def determine_day(day_word)
    date = case day_word
           when 'yesterday' then 1.day.ago
           when 'today' then Time.zone.now
           when 'tomorrow' then 1.day.from_now
           end.to_date.to_s
    Time.zone.parse("#{date} 12:30:30")
  end

  def package_date_format
    '%B %d, %Y'
  end

  def package_timestamp_format
    '%r'
  end
end

World(DataManipulationHelper)

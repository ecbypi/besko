class WeekPagination
  attr_reader :current_week
  attr_reader :next_week
  attr_reader :previous_week

  class Week
    attr_reader :finish
    attr_reader :range
    attr_reader :start

    def initialize(start)
      @start = start
      @finish = start + 6.days
    end

    def to_range
      @start..@finish
    end

    def to_s
      start_month = I18n.l(start, format: "%b")
      start_day = start.day

      finish = start + 6.days
      finish_month = I18n.l(finish, format: "%b")
      finish_day = finish.day

      if start_month != finish_month
        "#{start_month} #{start_day} - #{finish_month} #{finish_day}"
      else
        "#{start_month} #{start_day} - #{finish_day}"
      end
    end

    def days
      (@start..@finish).to_a
    end

    def previous
      Week.new @start - 1.week
    end

    def next
      Week.new @start + 1.week
    end
  end

  def initialize(initial_value)
    @current_week = case initial_value
                    when String
                      Week.new Date.parse(initial_value)
                    when Date
                      Week.new(initial_value)
                    when nil
                      Week.new Date.current.beginning_of_week
                    end

    @previous_week = @current_week.previous
    @next_week = @current_week.next
  end
end

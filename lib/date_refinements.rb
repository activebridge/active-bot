# frozen_string_literal: true

module DateRefinements
  refine Date.singleton_class do
    def last_business_day(date = Date.today)
      beginning_of_month = date.beginning_of_month

      day = beginning_of_month.next_month
      loop do
        day = day.prev_day
        break unless day.saturday? || day.sunday?
      end
      day
    end
    alias_method :last_business_day_for_current_month, :last_business_day

    def workdays
      d1 = Date.new(Time.now.year, Time.now.month, 1) # first day of month\period
      d2 = Date.new(Time.now.year, Time.now.month, -1) # end day of month\period
      wdays = [0, 6] # weekend days by numbers on week
      (d1..d2).reject { |d| wdays.include? d.wday } # Day.wday number day in week
    end
    alias_method :current_month_workdays, :workdays
  end
end
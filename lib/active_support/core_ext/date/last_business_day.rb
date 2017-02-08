# frozen_string_literal: true
require 'date'

class Date
  class << self
    def last_business_day(date = Date.today)
      beginning_of_month = date.beginning_of_month

      day = beginning_of_month.next_month
      loop do
        day = day.prev_day
        break unless day.saturday? || day.sunday?
      end
      day
    end
    alias last_business_day_for_current_month last_business_day
  end
end

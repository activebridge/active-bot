# frozen_string_literal: true
module Bot
  module Realtime
    class Dayoff < Base
      extend ExecutionHooks
      after_hook :notify

      def list
        dayoffs = company.day_offs.general + user.day_offs
        @text = list_of_dates(dayoffs.map(&:date))
      end

      def add
        return if user.developer?
        company.day_offs << ::DayOff.find_or_create_by(date: convert_to_date(value))
        @text = "Day Off #{value} has been created."
      end

      # TODO: delete personal dayoff's
      def delete
        if user.admin? || user.accountant?
          company.day_offs.where(date: convert_to_date(value)).delete_all
          @text = "Day Off #{value} has been deleted."
        else
          @text = "You are not able to delete a dayoff: #{value}."
        end
      end

      def vacation
        @text = "You have a vacation for `#{range.count} working days`. (#{range.first} - #{range.last})"
        range.each { |day| company.day_offs.create!(date: day, user: user) }
      end

      private

      def range
        @range ||= workdays_range
      end

      def workdays_range
        from = Date.parse(value) # first day
        to = convert_to_date(value.split('to')[-1]) # last day

        (from..to).reject { |d| [0, 6].include? d.wday } # only workdays
      rescue
        []
      end

      def convert_to_date(a_string)
        Date.parse(a_string)
      rescue
        Date.today + 1.day
      end

      using DateRefinements
      def list_of_dates(dates)
        Date.print_dates(dates)
      end
    end
  end
end

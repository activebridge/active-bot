# frozen_string_literal: true
module Bot
  module Realtime
    class Dayoff < Base
      extend ExecutionHooks
      after_hook :notify

      def list
        @text = company.day_offs.map(&:date).join("\n")
      end

      def add
        company.day_offs << ::DayOff.find_or_create_by(date: convert_to_date(value))
        @text = "Day Off #{value} has been created."
      end

      def delete
        company.day_offs.where(date: convert_to_date(value)).delete_all
        @text = "Day Off #{value} has been deleted."
      end

      def vocation
        @text = "You have a vocation for `#{range.count} working days`. (#{range.first} - #{range.last})"
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
    end
  end
end

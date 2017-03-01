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

      private

      def convert_to_date(a_string)
        Date.parse(a_string)
      rescue
        Date.today + 1.day
      end
    end
  end
end

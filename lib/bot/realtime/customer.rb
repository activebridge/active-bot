# frozen_string_literal: true
module Bot
  module Realtime
    class Customer < Base
      extend ExecutionHooks
      after_hook :notify

      def list
        @text = company.customers.map(&:name).join("\n")
      end

      def add
        company.customers << ::Customer.find_or_create_by(name: value)
        @text = "Customer #{value} has been created."
      end

      def delete
        company.customers.where(name: value).delete_all
        @text = "Customer #{value} has been deleted."
      end
    end
  end
end

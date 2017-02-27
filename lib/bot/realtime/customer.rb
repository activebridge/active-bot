# frozen_string_literal: true
module Bot
  module Realtime
    class Customer < Base
      def list
        notify(company.customers.map(&:name).join("\n"))
      end

      def add
        company.customers << ::Customer.find_or_create_by(name: value)
        notify("Customer #{value} has been created.")
      end

      def delete
        company.customers.where(name: value).delete_all
        notify("Customer #{value} has been deleted.")
      end
    end
  end
end

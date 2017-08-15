# frozen_string_literal: true
class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  delegate :name, to: :customer, prefix: true

  validates_numericality_of :hours, only_integer: true, greater_than: 0, less_than_or_equal_to: 400, allow_nil: true

  scope :last_months, -> { where(created_at: last_month_daterange) }

  class << self
    def last_month_daterange
      today = Date.today
      return ((last_business_day_for_current_month)..today.to_date.end_of_month) if today >= last_business_day_for_current_month && today <= today.to_date.end_of_month
      (last_business_day_for_prev_month..today)
    end

    using DateRefinements
    def last_business_day_for_current_month
      @last_business_day_for_current_month ||= Date.last_business_day_for_current_month
    end

    def last_business_day_for_prev_month
      @last_business_day_for_prev_month ||= Date.last_business_day(last_business_day_for_current_month << 1)
    end
  end

  private_class_method :last_business_day_for_current_month, :last_business_day_for_prev_month
end

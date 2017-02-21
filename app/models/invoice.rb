# frozen_string_literal: true
class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  delegate :name, to: :customer, prefix: true

  validates_numericality_of :hours, only_integer: true, greater_than: 0, less_than_or_equal_to: 400, allow_nil: true

  scope :this_months, lambda do
    where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
  end
end

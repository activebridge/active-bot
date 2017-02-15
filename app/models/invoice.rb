# frozen_string_literal: true
class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  validates_numericality_of :hours, only_integer: true, greater_than: 0, less_than_or_equal_to: 400

  scope :this_months, -> {
    where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
  }
end

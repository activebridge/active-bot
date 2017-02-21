class DayOff < ApplicationRecord
  belongs_to :company
  belongs_to :user, optional: true

  validates :date, presence: true

  scope :this_months, -> {
    where(date: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
  }

  scope :general, -> { where(user: nil) }
end
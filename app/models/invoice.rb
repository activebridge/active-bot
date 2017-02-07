class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :user

  validates :hours, presence: true
end

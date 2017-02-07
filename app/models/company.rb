class Company < ApplicationRecord
  has_many :customers

  validates :name, :wave_business_id, presence: true
end

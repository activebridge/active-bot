# frozen_string_literal: true
class Company < ApplicationRecord
  has_many :customers

  validates :name, :wave_business_id, presence: true

  def self.default
    # wave_business_id is fake for now
    find_or_create_by(name: 'Active Bridge LLC', wave_business_id: 0)
  end

  def default_customer
    customers.first
  end
end

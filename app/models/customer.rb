# frozen_string_literal: true
class Customer < ApplicationRecord
  belongs_to :company
  has_many :invoices

  validates :name, :wave_customer_id, presence: true
end

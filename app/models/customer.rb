# frozen_string_literal: true
class Customer < ApplicationRecord
  belongs_to :company
  has_many :invoices

  validates :name, presence: true
end

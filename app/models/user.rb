# frozen_string_literal: true
class User < ApplicationRecord
  belongs_to :company
  has_many :invoices

  validates :slack_name, presence: true

  scope :active, -> { where(deleted: false) }
end

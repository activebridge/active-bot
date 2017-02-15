# frozen_string_literal: true
class User < ApplicationRecord
  belongs_to :company
  has_many :invoices

  validates :slack_name, presence: true

  scope :active, -> { where(deleted: false) }

  def last_customer
    invoices.last&.customer || company.default_customer
  end

  def self.accountant
    find_by(role: 'accountant') || find_by(slack_name: 'alexmarchenko')
  end
end

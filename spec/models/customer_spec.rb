# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:invoices) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end

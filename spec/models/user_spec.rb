# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:invoices) }
  end

  context 'validations' do
    it { should validate_presence_of(:slack_name) }
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:customer) }
  end

  context 'validations' do
    it { should validate_numericality_of(:hours).only_integer.is_greater_than(0).is_less_than_or_equal_to(400) }
  end

  context 'scopes' do
    context '#this_months' do
      let!(:this_months_invoices) { create_list(:invoice, 3) }
      let!(:invoices) { create_list(:invoice, 2, created_at: Time.zone.now + 1.month) }

      it 'count' do
        expect(Invoice.count).to eq 5
        expect(Invoice.last_months.count).to eq 3
      end
    end
  end
end

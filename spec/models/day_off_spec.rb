# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DayOff, type: :model do
  context 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:date) }
  end

  context 'scopes' do
    context '#this_months' do
      let!(:this_months_day_offs) { create_list(:day_off, 3) }
      let!(:day_offs) { create_list(:day_off, 2, date: Date.current + 1.month) }

      it 'count' do
        expect(DayOff.count).to eq 5
        expect(DayOff.this_months.count).to eq 3
      end
    end

    context '#this_years' do
      let!(:this_months_day_offs) { create_list(:day_off, 3) }
      let!(:day_offs) { create_list(:day_off, 2, date: Date.current - 2.years) }

      it 'count' do
        expect(DayOff.count).to eq 5
        expect(DayOff.this_years.count).to eq 3
      end
    end

    context '#general' do
      let!(:general_day_offs) { create_list(:day_off, 3, user: nil) }
      let!(:user_day_offs) { create_list(:day_off, 2) }

      it 'count' do
        expect(DayOff.count).to eq 5
        expect(DayOff.general.count).to eq 3
      end
    end
  end
end

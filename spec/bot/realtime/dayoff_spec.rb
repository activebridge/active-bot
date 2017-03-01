# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Bot::Realtime::Dayoff do
  let(:company) { create(:company) }
  let(:dayoff_date) { attributes_for(:day_off)[:date].to_s }
  let(:params) { { company: company, channel_id: 'channelId', value: dayoff_date } }
  let(:subject) { Bot::Realtime::Dayoff.new(params) }

  before do
    allow_any_instance_of(Bot::Realtime::Dayoff).to receive(:notify).and_return(true)
  end

  describe '#list' do
    let!(:dayoffs) { create_list(:day_off, 5, company: company) }
    let(:dayoff_list) { dayoffs.map(&:date).join("\n") }
    it 'of dayoffs' do
      subject.list
      expect(subject.text).to eq dayoff_list
    end
  end

  describe '#add' do
    let(:text) { "Day Off #{dayoff_date} has been created." }
    it 'new dayoff' do
      expect { subject.add }.to change(DayOff, :count).by(1)
      expect(subject.text).to eq text
    end
  end

  describe '#delete' do
    let!(:dayoff) { create(:day_off, company: company, date: dayoff_date) }
    let(:text) { "Day Off #{dayoff_date} has been deleted." }
    it 'a dayoff' do
      expect { subject.delete }.to change(DayOff, :count).by(-1)
      expect(subject.text).to eq text
    end
  end
end

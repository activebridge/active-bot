# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'associations' do
    it { should have_many(:customers) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:wave_business_id) }
  end

  describe '.default' do
    it { expect(subject.class.default).to be_a Company }
    it { expect(subject.class.default.name).to eq 'Active Bridge LLC' }
    it { expect(subject.class.default.wave_business_id).to eq 0 }
  end
end

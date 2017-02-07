require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'associations' do
    it { should have_many(:customers) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:wave_business_id) }
  end
end

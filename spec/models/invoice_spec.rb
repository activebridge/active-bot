require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:customer) }
  end

  context 'validations' do
    it { should validate_presence_of(:hours) }
  end
end

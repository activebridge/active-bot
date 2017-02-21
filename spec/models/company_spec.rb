# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'associations' do
    it { should have_many(:customers) }
    it { should have_many(:users) }
    it { should have_many(:day_offs) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '.default' do
    it { expect(subject.class.default).to be_a Company }
    it { expect(subject.class.default.name).to eq 'Active Bridge LLC' }
  end

  describe '#default_customer' do
    let!(:company) { create(:company) }
    let!(:company_customers) { create_list(:customer, 4, company: company) }
    let!(:other_customers) { create_list(:customer, 3) }

    it { expect(company.default_customer).to eq company_customers.first }
  end

  describe '#accountant' do
    let!(:company) { create(:company) }
    let!(:accountant) { create(:user, role: 'accountant', company: company) }
    it { expect(company.accountant.name).to eq accountant.name }
  end
end

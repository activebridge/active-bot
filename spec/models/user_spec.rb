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

  context 'scopes' do
    context '#active' do
      let!(:users) { create_list(:user, 3) }
      let!(:deleted_users) { create_list(:user, 2, deleted: true) }

      it 'active' do
        expect(User.count).to eq 5
        expect(User.active.count).to eq 3
      end
    end

    context '#developers' do
      let!(:users) { create_list(:user, 3) }
      let!(:developers_users) { create_list(:user, 2, role: 'admin') }

      it 'developers' do
        expect(User.count).to eq 5
        expect(User.developers.count).to eq 3
      end
    end
  end

  describe '.accountant' do
    let!(:accountant) { create(:user, role: 'accountant') }
    it { expect(subject.class.accountant.name).to eq accountant.name }
  end

  describe '#last_customer' do
    let!(:company) { create(:company) }
    let(:user_with_invoice) { create(:user, company: company) }
    let!(:user_without_invoice) { create(:user, company: company) }
    let!(:invoice) { create(:invoice, user: user_with_invoice) }

    it { expect(user_with_invoice.last_customer).to eq invoice.customer  }
    it { expect(user_without_invoice.last_customer).to eq company.default_customer  }
  end
end

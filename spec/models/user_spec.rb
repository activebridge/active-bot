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
  end
end

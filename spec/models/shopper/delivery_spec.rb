require 'rails_helper'

module Shopper
  RSpec.describe Delivery, type: :model do
    subject(:delivery) { FactoryGirl.create :delivery }

    describe 'Validation' do
      it { expect(delivery).to validate_presence_of(:name) }
      it { expect(delivery).to validate_presence_of(:price) }
      it { expect(delivery).to validate_numericality_of(:price) }
    end

    describe 'Associations' do
      it { expect(delivery).to have_many(:orders) }
    end

    describe '#to_s' do
      it 'returns #name' do
        expect(delivery.to_s).to eq(delivery.name)
      end
    end
  end
end

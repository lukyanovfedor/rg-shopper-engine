require 'rails_helper'

module Shopper
  RSpec.describe OrderItem, type: :model do
    subject(:order_item) { FactoryGirl.create :order_item }

    describe 'Validation' do
      it { expect(order_item).to validate_presence_of(:order) }
      it { expect(order_item).to validate_presence_of(:product) }
      it { expect(order_item).to validate_presence_of(:quantity) }

      it { expect(order_item).to validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }
    end

    describe 'Associations' do
      it { expect(order_item).to belong_to(:order) }
      it { expect(order_item).to belong_to(:product) }
    end

    describe '#total_price' do
      it 'should return product#price * order_item#quantity rounded to 2' do
        expect(order_item.total_price).to eq((order_item.product.price * order_item.quantity).round(2))
      end
    end
  end
end

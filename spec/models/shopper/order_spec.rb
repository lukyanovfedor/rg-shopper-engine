require 'rails_helper'

module Shopper
  RSpec.describe Order, type: :model do
    subject(:order) { FactoryGirl.create(:order) }

    describe 'Enum' do
      it { expect(order).to define_enum_for(:state).with(%i(in_progress in_queue in_delivery delivered canceled)) }
    end

    describe 'Associations' do
      it { expect(order).to belong_to(:delivery) }
      it { expect(order).to belong_to(:customer) }
      it { expect(order).to have_one(:billing_address).dependent(:destroy) }
      it { expect(order).to have_one(:shipping_address).dependent(:destroy) }
      it { expect(order).to have_one(:credit_card).dependent(:destroy) }
      it { expect(order).to have_many(:order_items).dependent(:destroy) }
    end

    describe 'Nested attributes' do
      it { expect(order).to accept_nested_attributes_for(:billing_address) }
      it { expect(order).to accept_nested_attributes_for(:shipping_address) }
      it { expect(order).to accept_nested_attributes_for(:credit_card) }
    end

    describe 'States' do
      let!(:order) { FactoryGirl.create(:order_with_items) }

      describe '#place_order' do
        it 'expect to allow transition from :in_progress to :in_queue' do
          order.place_order
          expect(order).to be_in_queue
        end

        it 'expect to not allow transition to :in_queue without billing_address' do
          order.update(billing_address: nil)
          expect(order.place_order).to be_falsy
        end

        it 'expect to not allow transition to :in_queue without shipping_address' do
          order.update(shipping_address: nil)
          expect(order.place_order).to be_falsy
        end

        it 'expect to not allow transition to :in_queue without delivery' do
          order.update(delivery: nil)
          expect(order.place_order).to be_falsy
        end

        it 'expect to not allow transition to :in_queue without credit card' do
          order.update(credit_card: nil)
          expect(order.place_order).to be_falsy
        end
      end

      describe '#start_delivery' do
        let(:order) { FactoryGirl.create(:order, state: 1) }

        it 'expect to allow transition from :in_queue to :in_delivery' do
          order.start_delivery
          expect(order).to be_in_delivery
        end
      end

      describe '#end_delivery' do
        let(:order) { FactoryGirl.create(:order, state: 2) }

        it 'expect to allow transition from :in_delivery to :delivered' do
          order.end_delivery
          expect(order).to be_delivered
        end
      end

      describe '#cancel' do
        it 'expect to allow transition to :canceled' do
          order.cancel
          expect(order).to be_canceled
        end
      end
    end

    describe '#ready_for_close?' do
      let!(:order) { FactoryGirl.create(:order_with_items) }

      it 'expect to be false without billing address' do
        order.billing_address = nil
        expect(order.ready_for_close?).to be_falsy
      end

      it 'expect to be false without shipping address' do
        order.shipping_address = nil
        expect(order.ready_for_close?).to be_falsy
      end

      it 'expect to be false without delivery' do
        order.delivery = nil
        expect(order.ready_for_close?).to be_falsy
      end

      it 'expect to be false without credit card' do
        order.credit_card = nil
        expect(order.ready_for_close?).to be_falsy
      end

      it 'expect to be false without order_items' do
        OrderItem.destroy_all
        order.order_items.reload
        expect(order.ready_for_close?).to be_falsy
      end

      it 'expect to be true with credit card, delivery, addresses and order_items' do
        expect(order.ready_for_close?).to be_truthy
      end
    end

    describe '#to_s' do
      it 'expect to return "order" with id' do
        expect(order.to_s).to eq "Order #{order.id}"
      end
    end

    describe '#add_product' do
      let(:quantity) { 2 }

      context 'with order_item that contain product' do
        let(:order_item) { FactoryGirl.create(:order_item, order: order) }

        it 'expect to update order_item with order_item.quantity + quantity' do
          old = order_item.quantity
          order.add_product(order_item.product, quantity)
          order_item.reload
          expect(order_item.quantity).to eq(old + quantity)
        end
      end

      context 'without order_item that contain product' do
        let(:product) { FactoryGirl.create(:product) }

        it 'expect to create new order item' do
          old = order.order_items.size
          order.add_product(product, quantity)
          order.order_items.reload
          expect(order.order_items.size).to eq(old + 1)
        end
      end
    end

    describe '#remove_product' do
      let!(:order_item) { FactoryGirl.create(:order_item, order: order) }

      context 'with quantity less then order_item quantity' do
        it 'expect to update order_item with order_item.quantity + quantity' do
          order.remove_product(order_item.product, order_item.quantity - 1)
          order_item.reload
          expect(order_item.quantity).to eq(1)
        end
      end

      context 'with quantity equal or more then order_item quantity' do
        it 'expect to destroy order_item' do
          old = order.order_items.size
          order.remove_product(order_item.product, order_item.quantity)
          order.order_items.reload
          expect(order.order_items.size).to eq(old - 1)
        end
      end
    end

    describe '#items_price' do
      let!(:order_item) { FactoryGirl.create(:order_item, order: order) }

      it 'expect to return sum of order_items.total_price rounded to 2' do
        expect(order.items_price).to eq((order_item.product.price * order_item.quantity).round(2))
      end
    end

    describe '#items_price' do
      let!(:product_1) { FactoryGirl.create(:product, price: 10) }
      let!(:order_item_1) { FactoryGirl.create(:order_item, quantity: 1, product: product_1, order: order) }
      let!(:product_2) { FactoryGirl.create(:product, price: 20) }
      let!(:order_item_2) { FactoryGirl.create(:order_item, quantity: 1, product: product_2, order: order) }

      it 'expect to return sum of order_items.total_price rounded to 2' do
        expect(order.items_price).to eq(30.round(2))
      end
    end

    describe '#total_price' do
      let!(:product_1) { FactoryGirl.create(:product, price: 10) }
      let!(:order_item_1) { FactoryGirl.create(:order_item, quantity: 1, product: product_1, order: order) }
      let!(:product_2) { FactoryGirl.create(:product, price: 20) }
      let!(:order_item_2) { FactoryGirl.create(:order_item, quantity: 1, product: product_2, order: order) }
      let!(:delivery) { FactoryGirl.create(:delivery, price: 20) }

      it 'expect to return items_price + delivery.price rounded to 2' do
        order.update(delivery: delivery)
        expect(order.total_price).to eq(50.round(2))
      end
    end
  end
end

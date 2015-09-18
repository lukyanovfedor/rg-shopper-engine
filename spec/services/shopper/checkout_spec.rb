require 'rails_helper'

module Shopper
  RSpec.describe Checkout do
    let!(:order) { FactoryGirl.create(:order_with_items) }
    let!(:checkout) { Checkout.new(order, nil) }

    describe '#build_credit_card' do
      context 'order with credit_card' do
        it 'expect to not receive build_credit_card' do
          expect(order).not_to receive(:build_credit_card)
          checkout.build_credit_card
        end
      end

      context 'order without credit_card' do
        it 'expect to receive build_credit_card' do
          order.credit_card = nil
          expect(order).to receive(:build_credit_card)
          checkout.build_credit_card
        end
      end
    end

    describe '#set_params' do
      it 'expect to receive assign_attributes with prms' do
        prms = { title: 'hello' }
        expect(order).to receive(:assign_attributes).with(prms)
        checkout.set_params(prms)
      end
    end

    describe '#update_addresses' do
      let(:prms) do
        {
          shipping_address_attributes: { title: 'Shipping address' },
          billing_address_attributes: { title: 'Billing address' }
        }
      end

      it 'expect to receive :set_params with prms' do
        expect(checkout).to receive(:set_params).with(prms)
        checkout.update_addresses(prms)
      end

      it 'expect to change shipping_address_attributes with billing_address_attributes, if param billing_as_shipping is truly' do
        expect(checkout).to receive(:set_params).with({
          shipping_address_attributes: { title: 'Billing address' },
          billing_address_attributes: { title: 'Billing address' }
        })

        checkout.update_addresses(prms, true)
      end
    end

    describe '#update_delivery' do
      let(:delivery) { FactoryGirl.create(:delivery) }
      let(:prms) { { delivery_id: delivery.id } }

      before { Delivery.destroy_all }

      context 'delivery not exist' do
        it 'expect to return false' do
          prms[:delivery_id] = prms[:delivery_id] + 1
          expect(checkout.update_delivery(prms)).to be_falsey
        end
      end

      context 'delivery exist' do
        before { allow(Delivery).to receive(:find).with(delivery.id) { delivery } }

        it 'expect to receive delivery=' do
          expect(order).to receive(:delivery=).with(delivery)
          checkout.update_delivery(prms)
        end

        it 'expect to return true' do
          expect(checkout.update_delivery(prms)).to be_truthy
        end
      end
    end

    describe '#place_order' do
      it 'expect to call place_order' do
        expect(order).to receive(:place_order)
        checkout.place_order
      end

      context 'with user' do
        let!(:user) { double('User') }
        let!(:checkout) { Checkout.new(order, user) }

        it 'expect to receive customer=' do
          expect(order).to receive(:customer=).with(user)
          checkout.place_order
        end
      end
    end

    describe '#build_addresses' do
      it 'expect to receive build_billing_address, if order without billing' do
        order.billing_address = nil
        expect(order).to receive(:build_billing_address)
        checkout.build_addresses
      end

      it 'expect to not receive build_billing_address, if order with billing' do
        expect(order).not_to receive(:build_billing_address)
        checkout.build_addresses
      end

      it 'expect to receive build_shipping_address, if order without shipping' do
        order.shipping_address = nil
        expect(order).to receive(:build_shipping_address)
        checkout.build_addresses
      end

      it 'expect to not receive build_billing_address, if order with billing' do
        expect(order).not_to receive(:build_shipping_address)
        checkout.build_addresses
      end
    end
  end
end
require 'rails_helper'

module Shopper
  RSpec.describe CheckoutController, type: :controller do
    routes { Shopper::Engine.routes }

    let!(:order) { FactoryGirl.create :order_with_items }
    let!(:empty_order) { FactoryGirl.create :order }
    let!(:checkout) { Checkout.new(order, nil) }

    before do
      allow(controller).to receive(:current_order) { order }
      allow(Checkout).to receive(:new) { checkout }
    end

    describe '#show' do
      context 'order with items' do
        it 'expect to assign order' do
          get :show, id: 'address'
          expect(assigns(:order)).not_to be_nil
        end

        it 'expect to assign checkout' do
          get :show, id: 'address'
          expect(assigns(:checkout)).not_to be_nil
        end

        context 'step address' do
          it { expect(get :show, id: 'address').to render_template('address') }

          it 'expect to assign countries' do
            get :show, id: 'address'
            expect(assigns(:countries)).not_to be_nil
          end

          it 'expect to receive build_addresses' do
            expect(checkout).to receive(:build_addresses)
            get :show, id: 'address'
          end
        end

        context 'step delivery' do
          it { expect(get :show, id: 'delivery').to render_template('delivery') }

          it 'expect to assign deliveries' do
            get :show, id: 'delivery'
            expect(assigns(:deliveries)).not_to be_nil
          end
        end

        context 'step payment' do
          it { expect(get :show, id: 'payment').to render_template('payment') }

          it 'expect to receive build_credit_card' do
            expect(checkout).to receive(:build_credit_card)
            get :show, id: 'payment'
          end
        end

        context 'step confirm' do
          it { expect(get :show, id: 'confirm').to render_template('confirm') }

          it 'expect to redirect to :address if order without billing' do
            order.billing_address = nil
            expect(get :show, id: 'confirm').to redirect_to checkout_path(:address)
          end

          it 'expect to alert if order without billing' do
            order.billing_address = nil
            get :show, id: 'confirm'
            expect(flash[:alert]).not_to be_nil
          end

          it 'expect to redirect to :address if order without shipping' do
            order.shipping_address = nil
            expect(get :show, id: 'confirm').to redirect_to checkout_path(:address)
          end

          it 'expect to alert if order without shipping' do
            order.shipping_address = nil
            get :show, id: 'confirm'
            expect(flash[:alert]).not_to be_nil
          end

          it 'expect to redirect to :delivery if order without delivery' do
            order.delivery = nil
            expect(get :show, id: 'confirm').to redirect_to checkout_path(:delivery)
          end

          it 'expect to alert if order without delivery' do
            order.delivery = nil
            get :show, id: 'confirm'
            expect(flash[:alert]).not_to be_nil
          end

          it 'expect to redirect to :payment if order without credit_card' do
            order.credit_card = nil
            expect(get :show, id: 'confirm').to redirect_to checkout_path(:payment)
          end

          it 'expect to alert if order without credit_card' do
            order.credit_card = nil
            get :show, id: 'confirm'
            expect(flash[:alert]).not_to be_nil
          end
        end

        context 'step wicked_finish' do
          it { expect(get :show, id: 'wicked_finish').to redirect_to complete_cart_path }
        end
      end

      context 'order without items' do
        it 'expect to raise ActionController::RoutingError' do
          allow(controller).to receive(:current_order) { empty_order }
          expect { get :show, id: 'address' }.to raise_error(ActionController::RoutingError)
        end
      end
    end

    describe '#update' do
      context 'order with items' do
        it 'expect to assign order' do
          put :update, id: 'address'
          expect(assigns(:order)).not_to be_nil
        end

        it 'expect to assign checkout' do
          put :update, id: 'address'
          expect(assigns(:checkout)).not_to be_nil
        end

        context 'step address' do
          it 'expect to assign countries' do
            put :update, id: 'address'
            expect(assigns(:countries)).not_to be_nil
          end

          it 'expect to receive update_addresses' do
            expect(checkout).to receive(:update_addresses)
            put :update, id: 'address'
          end
        end

        context 'step delivery' do
          it 'expect to receive update_delivery' do
            expect(checkout).to receive(:update_delivery)
            put :update, id: 'delivery'
          end
        end

        context 'step payment' do
          it 'expect to receive set_params' do
            expect(checkout).to receive(:set_params)
            put :update, id: 'payment'
          end
        end

        context 'step confirm' do
          it 'expect to receive place_order' do
            expect(checkout).to receive(:place_order)
            put :update, id: 'confirm'
          end
        end
      end

      context 'order without items' do
        it 'expect to raise ActionController::RoutingError' do
          allow(controller).to receive(:current_order) { empty_order }
          expect { put :update, id: 'address' }.to raise_error(ActionController::RoutingError)
        end
      end
    end
  end
end

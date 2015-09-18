require 'rails_helper'

module Shopper
  RSpec.describe OrderController, type: :controller do
    routes { Shopper::Engine.routes }

    let(:order) { FactoryGirl.create(:order) }
    let(:product) { FactoryGirl.create(:product) }

    before { allow(controller).to receive(:current_order) { order } }

    describe '#add_product' do
      it 'should assign @product' do
        post :add_product, class: product.product_type, id: product.id
        expect(assigns(:product)).not_to be_nil
      end

      it 'it expect to redirect to root_path' do
        post :add_product, class: product.product_type, id: product.id
        expect(response).to redirect_to(root_path)
      end

      it 'it expect to receive add_product' do
        expect(order).to receive(:add_product)
        post :add_product, class: product.product_type, id: product.id
      end

      context 'product added successfully' do
        before { allow(order).to receive(:add_product) { true } }

        it 'expect to send notice' do
          post :add_product, class: product.product_type, id: product.id
          expect(flash[:notice]).not_to be_nil
        end
      end

      context 'product not added' do
        before { allow(order).to receive(:add_product) { false } }

        it 'expect to send alert' do
          post :add_product, class: product.product_type, id: product.id
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

    describe '#remove_product' do
      it 'should assign @product' do
        delete :remove_product, class: product.product_type, id: product.id
        expect(assigns(:product)).not_to be_nil
      end

      it 'it expect to redirect to root_path' do
        delete :remove_product, class: product.product_type, id: product.id
        expect(response).to redirect_to(root_path)
      end

      it 'it expect to receive add_product' do
        expect(order).to receive(:remove_product)
        delete :remove_product, class: product.product_type, id: product.id
      end

      context 'product removed successfully' do
        before { allow(order).to receive(:remove_product) { true } }

        it 'expect to send notice' do
          delete :remove_product, class: product.product_type, id: product.id
          expect(flash[:notice]).not_to be_nil
        end
      end

      context 'product not remoed' do
        before { allow(order).to receive(:remove_product) { false } }

        it 'expect to send alert' do
          delete :remove_product, class: product.product_type, id: product.id
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

  end
end

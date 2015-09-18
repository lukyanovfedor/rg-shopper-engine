require 'rails_helper'

RSpec.describe "shopper/cart/_cart_items", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }
  let(:order_item) { order.order_items.first }

  context 'without edit' do
    before { render partial: 'shopper/cart/cart_items', locals: { items: order.order_items, edit: false } }

    it 'expect to render table rows as items count' do
      expect(rendered).to have_css('table tbody tr', count: order.order_items.size)
    end

    it { expect(rendered).to have_content(order_item.product.title) }
    it { expect(rendered).to have_content(order_item.product.price) }
    it { expect(rendered).to have_content(order_item.quantity) }
    it { expect(rendered).to have_content(order_item.total_price) }
  end

  context 'with edit' do
    before { render partial: 'shopper/cart/cart_items', locals: { items: order.order_items, edit: true } }

    it 'expect to render remove item form' do
      expect(rendered).to have_css('form.remove-product')
    end
  end
end

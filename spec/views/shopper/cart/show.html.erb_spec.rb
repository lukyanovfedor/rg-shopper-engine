require 'rails_helper'

RSpec.describe "shopper/cart/show", type: :view do
  context 'with order items' do
    let(:order) { FactoryGirl.create(:order_with_items) }

    it 'expect to render _cart_items partial' do
      assign(:order, order)
      render
      expect(view).to render_template(partial: 'shopper/cart/_cart_items')
    end
  end

  context 'without order items' do
    let(:order) { FactoryGirl.create(:order) }

    it 'expect to render empty message' do
      assign(:order, order)
      render
      expect(rendered).to have_content(t('cart.empty'))
    end
  end
end

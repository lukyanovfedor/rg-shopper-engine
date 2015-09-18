require 'rails_helper'

RSpec.describe "shopper/checkout/_summary", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before { render partial: 'shopper/checkout/summary', locals: { order: order } }

  it 'expect to render order items price' do
    expect(rendered).to have_content(order.items_price)
  end

  it 'expect to render rounded order delivery price' do
    expect(rendered).to have_content(order.delivery.price.round(2))
  end

  it 'expect to render order total price' do
    expect(rendered).to have_content(order.total_price)
  end
end

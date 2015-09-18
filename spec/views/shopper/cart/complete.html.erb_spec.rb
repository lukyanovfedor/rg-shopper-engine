require 'rails_helper'

RSpec.describe "shopper/cart/complete", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before do
    assign(:order, order)
    render
  end

  it { expect(view).to render_template(partial: 'shopper/cart/_cart_items') }
  it { expect(view).to render_template(partial: 'shopper/helpers/_order') }
  it { expect(view).to render_template(partial: 'shopper/checkout/_summary') }
end

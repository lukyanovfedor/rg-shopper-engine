require 'rails_helper'

RSpec.describe "shopper/checkout/confirm", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before do
    view.extend Shopper::CheckoutHelper

    allow(view).to receive(:wizard_progress) { [{}] }
    allow(view).to receive(:wizard_path) { 'http://fuck.it' }

    assign(:order, order)
    render
  end

  it { expect(rendered).to have_css('form') }
  it { expect(view).to render_template(partial: 'shopper/cart/_cart_items') }
  it { expect(view).to render_template(partial: 'shopper/helpers/_order') }
  it { expect(view).to render_template(partial: 'shopper/checkout/_summary') }
end

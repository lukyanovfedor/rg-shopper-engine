require 'rails_helper'

RSpec.describe "shopper/checkout/address", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before do
    view.extend Shopper::CheckoutHelper

    allow(view).to receive(:wizard_progress) { [{}] }
    allow(view).to receive(:wizard_path) { 'http://fuck.it' }

    assign(:order, order)
    assign(:countries, [FactoryGirl.create(:country)])
    render
  end

  it { expect(rendered).to have_css('form') }
  it { expect(rendered).to have_css('.billing-address-form') }
  it { expect(rendered).to have_css('.shipping-address-form') }
  it { expect(rendered).to have_css('input#same_as_billing') }
  it { expect(view).to render_template(partial: 'shopper/checkout/_summary') }
end

require 'rails_helper'

RSpec.describe "shopper/checkout/payment", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before do
    view.extend Shopper::CheckoutHelper

    allow(view).to receive(:wizard_progress) { [{}] }
    allow(view).to receive(:wizard_path) { 'http://fuck.it' }

    assign(:order, order)
    render
  end

  it { expect(rendered).to have_css('form') }
  it { expect(view).to render_template(partial: 'shopper/checkout/_summary') }
end

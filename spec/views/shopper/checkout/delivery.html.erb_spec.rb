require 'rails_helper'

RSpec.describe "shopper/checkout/delivery", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  before do
    view.extend Shopper::CheckoutHelper

    allow(view).to receive(:wizard_progress) { [{}] }
    allow(view).to receive(:wizard_path) { 'http://fuck.it' }

    assign(:order, order)
    assign(:deliveries, [FactoryGirl.create(:delivery), order.delivery])
    render
  end

  it { expect(rendered).to have_css('form') }
  it { expect(rendered).to have_css('.radio', count: 2) }
  it { expect(view).to render_template(partial: 'shopper/checkout/_summary') }
end

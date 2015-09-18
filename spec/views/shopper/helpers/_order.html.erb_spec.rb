require 'rails_helper'

RSpec.describe "shopper/helpers/_order", type: :view do
  let(:order) { FactoryGirl.create(:order_with_items) }

  context 'without edit' do
    before { render partial: 'shopper/helpers/order', locals: { order: order, edit: false } }

    it { expect(rendered).to have_content(order.billing_address.first_name) }
    it { expect(rendered).to have_content(order.billing_address.last_name) }
    it { expect(rendered).to have_content(order.billing_address.country) }
    it { expect(rendered).to have_content(order.billing_address.city) }
    it { expect(rendered).to have_content(order.billing_address.street) }
    it { expect(rendered).to have_content(order.billing_address.zip) }
    it { expect(rendered).to have_content(order.billing_address.phone) }

    it { expect(rendered).to have_content(order.shipping_address.first_name) }
    it { expect(rendered).to have_content(order.shipping_address.last_name) }
    it { expect(rendered).to have_content(order.shipping_address.country) }
    it { expect(rendered).to have_content(order.shipping_address.city) }
    it { expect(rendered).to have_content(order.shipping_address.street) }
    it { expect(rendered).to have_content(order.shipping_address.zip) }
    it { expect(rendered).to have_content(order.shipping_address.phone) }

    it { expect(rendered).to have_content(order.delivery.name) }
    it { expect(rendered).to have_content(order.delivery.price.round(2)) }

    it { expect(rendered).to have_content(order.credit_card.secure_number) }
    it { expect(rendered).to have_content(order.credit_card.expiration_date) }
  end
end

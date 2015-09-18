require 'rails_helper'

RSpec.feature "Cart", type: :feature do
  given(:product) { FactoryGirl.create(:product) }

  scenario 'Client can add product to cart' do
    visit(product_path(product))
    click_button('Add to cart')

    visit(shopper_path)

    expect(page).to have_content(product.title)
  end

  scenario 'Client can remove product from cart' do
    visit(product_path(product))
    click_button('Add to cart')

    visit(shopper_path)
    click_button('Remove')

    expect(page).not_to have_content(product.title)
  end
end

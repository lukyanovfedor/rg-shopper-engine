require 'rails_helper'

RSpec.feature "Checkout", type: :feature do
  given(:product) { FactoryGirl.create(:product) }
  given!(:country) { FactoryGirl.create(:country) }
  given!(:delivery) { FactoryGirl.create(:delivery) }

  background do
    visit(product_path(product))
    click_button('Add to cart')
    click_link('Checkout')
  end

  scenario 'User can fill billing and shipping address, to process to next step' do
    billing = FactoryGirl.attributes_for(:address)
    shipping = FactoryGirl.attributes_for(:address)
    within '.billing-address-form' do
      fill_address(billing, country)
    end
    within '.shipping-address-form' do
      fill_address(shipping, country)
    end
    click_button(I18n.t('checkout.next'))

    expect(page).to have_css('.delivery-form')
  end

  scenario 'User can fill billing and set checkbox "same_as_billing", to process to next step' do
    billing = FactoryGirl.attributes_for(:address)
    within '.billing-address-form' do
      fill_address(billing, country)
    end
    check('same_as_billing')
    click_button(I18n.t('checkout.next'))

    expect(page).to have_css('.delivery-form')
  end

  scenario 'User can fill delivery, to process to next step' do
    billing = FactoryGirl.attributes_for(:address)
    within '.billing-address-form' do
      fill_address(billing, country)
    end
    check('same_as_billing')
    click_button(I18n.t('checkout.next'))
    choose("order_delivery_id_#{delivery.id}")
    click_button(I18n.t('checkout.next'))

    expect(page).to have_css('.payment-form')
  end

  scenario 'User can fill payment, to process to next step' do
    billing = FactoryGirl.attributes_for(:address)
    credit_card = FactoryGirl.attributes_for(:credit_card)
    within '.billing-address-form' do
      fill_address(billing, country)
    end
    check('same_as_billing')
    click_button(I18n.t('checkout.next'))
    choose("order_delivery_id_#{delivery.id}")
    click_button(I18n.t('checkout.next'))
    within '.payment-form' do
      fill_payment(credit_card)
    end
    click_button(I18n.t('checkout.next'))

    expect(page).to have_css('.confirm')
  end

  scenario 'User can confirm order' do
    billing = FactoryGirl.attributes_for(:address)
    credit_card = FactoryGirl.attributes_for(:credit_card)
    within '.billing-address-form' do
      fill_address(billing, country)
    end
    check('same_as_billing')
    click_button(I18n.t('checkout.next'))
    choose("order_delivery_id_#{delivery.id}")
    click_button(I18n.t('checkout.next'))
    within '.payment-form' do
      fill_payment(credit_card)
    end
    click_button(I18n.t('checkout.next'))
    click_button(I18n.t('checkout.place_order'))

    expect(page).to have_content(I18n.t('checkout.finish.created'))
  end
end

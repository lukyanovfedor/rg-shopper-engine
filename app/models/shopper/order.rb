module Shopper
  class Order < ActiveRecord::Base
    include ::AASM

    has_many :order_items, dependent: :destroy

    has_one :billing_address, as: :addressable, dependent: :destroy
    accepts_nested_attributes_for :billing_address

    has_one :shipping_address, as: :addressable, dependent: :destroy
    accepts_nested_attributes_for :shipping_address

    has_one :credit_card, dependent: :destroy
    accepts_nested_attributes_for :credit_card

    belongs_to :customer, polymorphic: true
    belongs_to :delivery

    enum state: %i(in_progress in_queue in_delivery delivered canceled)

    aasm column: :state, enum: true, whiny_transitions: false  do
      state :in_progress, initial: true
      state :in_queue
      state :in_delivery
      state :delivered
      state :canceled

      event :place_order do
        transitions from: :in_progress, to: :in_queue, guard: :ready_for_close?
      end

      event :cancel do
        transitions from: %i(in_progress in_queue in_delivery delivered), to: :canceled
      end

      event :start_delivery do
        transitions from: :in_queue, to: :in_delivery
      end

      event :end_delivery do
        transitions from: :in_delivery, to: :delivered
      end
    end

    def to_s
      "Order #{self.id}"
    end

    def total_price
      (items_price + (delivery ? delivery.price : 0)).round(2)
    end

    def items_price
      price = order_items.map(&:total_price).inject(&:+)

      if price
        price.round(2)
      else
        0
      end
    end

    def add_product(product, quantity = 1)
      order_item = order_items.find_by(product: product)

      if order_item
        order_item.update(quantity: order_item.quantity + quantity.to_i)
      else
        order_items.create(product: product, quantity: quantity)
      end
    end

    def remove_product(product, quantity = 1)
      order_item = order_items.find_by(product: product)
      return false unless order_item

      order_item.quantity -= quantity.to_i

      if order_item.quantity > 0
        order_item.save
      else
        order_item.destroy
      end
    end

    def ready_for_close?
      billing_address.present? && shipping_address.present? &&
        credit_card.present? && delivery.present? && order_items.any?
    end
  end
end
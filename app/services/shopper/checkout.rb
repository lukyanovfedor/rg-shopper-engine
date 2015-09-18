module Shopper
  class Checkout
    def initialize(order, user)
      @order = order
      @user = user
    end

    def build_addresses
      build_billing
      build_shipping
    end

    def build_credit_card
      unless @order.credit_card
        @order.build_credit_card
      end
    end

    def update_addresses(prms, shipping_as_billing = false)
      prms ||= {}

      if shipping_as_billing
        prms[:shipping_address_attributes] = prms[:billing_address_attributes]
      end

      set_params(prms)
    end

    def update_delivery(prms)
      prms ||= {}

      delivery =
        begin
          Delivery.find(prms[:delivery_id])
        rescue ActiveRecord::RecordNotFound
          nil
        end

      if delivery
        @order.delivery = delivery
        true
      else
        false
      end
    end

    def place_order
      if @user
        @order.customer = @user
      end

      @order.place_order
    end

    def set_params(prms)
      prms ||= {}

      @order.assign_attributes(prms)
    end

    private

    def user_has_billing?
      @user.respond_to?(:billing_address) && @user.billing_address
    end

    def user_has_shipping?
      @user.respond_to?(:shipping_address) && @user.shipping_address
    end

    def build_billing
      unless @order.billing_address
        if user_has_billing?
          @order.build_billing_address(@user.billing_address.dup.attributes)
        else
          @order.build_billing_address
        end
      end
    end

    def build_shipping
      unless @order.shipping_address
        if user_has_shipping?
          @order.build_shipping_address(@user.shipping_address.dup.attributes)
        else
          @order.build_shipping_address
        end
      end
    end
  end
end
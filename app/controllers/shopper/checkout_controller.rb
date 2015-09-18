module Shopper
  class CheckoutController < ShopperController
    include Wicked::Wizard

    before_action :check_order, :set_order_and_checkout

    steps :address, :delivery, :payment, :confirm

    def show
      case step.to_sym
        when :address
          address
        when :delivery
          delivery
        when :payment
          credit_card
        when :confirm
          confirm
        when :wicked_finish
          finish
        else
      end

      render_wizard
    end

    def update
      case step.to_sym
        when :address
          update_address
        when :delivery
          update_delivery
        when :payment
          update_credit_card
        when :confirm
          place_order
        else
      end

      render_wizard @order
    end

    private

    def address
      @countries = Country.all
      @checkout.build_addresses
    end

    def update_address
      @countries = Country.all
      @checkout.update_addresses(addresses_params, params[:same_as_billing])
    end

    def delivery
      @deliveries = Delivery.all
    end

    def update_delivery
      unless @checkout.update_delivery(delivery_params)
        flash[:alert] = t('checkout.delivery.need_to_fill')
        jump_to(:delivery)
      end
    end

    def credit_card
      @checkout.build_credit_card
    end

    def update_credit_card
      @checkout.set_params(credit_card_params)
    end

    def confirm
      unless step_completed?(:address)
        flash[:alert] = t('checkout.billing.need_to_fill')
        return jump_to(:address)
      end

      unless step_completed?(:delivery)
        flash[:alert] = t('checkout.delivery.need_to_fill')
        return jump_to(:delivery)
      end

      unless step_completed?(:payment)
        flash[:alert] = t('checkout.payment.need_to_fill')
        jump_to(:payment)
      end
    end

    def place_order
      unless @checkout.place_order
        jump_to(:confirm)
      end
    end

    def finish
      flash[:order_id] = @order.id
      flash[:notice] = t('checkout.finish.created')

      create_current_order
    end

    def finish_wizard_path
      complete_cart_path
    end

    def step_completed?(step)
      case step
        when :address
          @order.billing_address && @order.shipping_address
        when :delivery
          @order.delivery
        when :payment
          @order.credit_card
        else
          false
      end
    end

    def address_fields
      %i(first_name last_name street city zip phone type country_id)
    end

    def addresses_params
      params.require(:order).permit(
          billing_address_attributes: address_fields,
          shipping_address_attributes: address_fields
      ) if params[:order]
    end

    def delivery_params
      params.require(:order).permit(:delivery_id) if params[:order]
    end

    def credit_card_params
      params.require(:order).permit(
          credit_card_attributes: %i(number expiration_month expiration_year cvv)
      ) if params[:order]
    end

    def check_order
      not_found if current_order.order_items.empty?
    end

    def set_order_and_checkout
      @order = current_order
      @checkout = Checkout.new(current_order, current_user)
    end
  end
end


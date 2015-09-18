module Shopper
  class OrderController < ShopperController
    before_action :set_product!

    def add_product
      respond_to do |format|
        if current_order.add_product(@product, params[:quantity])
          format.html { redirect_to root_path, notice: t('order.added') }
        else
          format.html { redirect_to root_path, alert: t('order.not_added') }
        end
      end
    end

    def remove_product
      respond_to do |format|
        if current_order.remove_product(@product, params[:quantity])
          format.html { redirect_to root_path, notice: t('order.removed') }
        else
          format.html { redirect_to root_path, alert: t('order.not_removed') }
        end
      end
    end

    protected

    def set_product!
      class_name = Shopper::PRODUCT_CLASSES.detect { |c| c == params[:class] }
      @product = class_name.camelize.constantize.find(params[:id])
    end
  end
end

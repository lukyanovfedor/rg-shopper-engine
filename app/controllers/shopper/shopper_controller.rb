module Shopper
  class ShopperController < Shopper.parent_controller.constantize
    before_action :set_current_order unless Shopper.set_order_on_each_request

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end

module Shopper
  module ApplicationHelper
    def beauty_price(price)
      '%.2f' % price
    end

    def method_missing(method, *args)
      if main_app_url_helper?(method)
        main_app.send(method, *args)
      else
        super
      end
    end

    private

    def main_app_url_helper?(method)
      (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) &&
        main_app.respond_to?(method)
    end
  end
end

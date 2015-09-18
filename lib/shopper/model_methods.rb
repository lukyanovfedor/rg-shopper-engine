module Shopper
  module ModelMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def register_as_product
        class_name = self.to_s.underscore
        Shopper::PRODUCT_CLASSES.push(class_name).uniq!

        extend_product(self)
      end

      def register_as_customer
        extend_customer(self)
      end

      private

      def extend_product(product_class)
        product_class.class_eval do
          def product_type
            self.class.to_s.underscore
          end

          scope :best_sellers, -> (num = 3) do
            self
              .select("#{self.table_name}.*, sum(shopper_order_items.quantity) as q")
              .joins(:order_items)
              .group(:id)
              .order('q DESC')
              .limit(num)
          end
        end

        product_class.send(:has_many, :order_items, {
          class_name: 'Shopper::OrderItem',
          as: :product,
          dependent: :destroy
        })
      end

      def extend_customer(customer_class)
        customer_class.send(:has_many, :orders, {
          class_name: 'Shopper::Order',
          as: :customer,
          dependent: :nullify
        })
      end
    end
  end
end
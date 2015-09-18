FactoryGirl.define do
  factory :order_item, :class => 'Shopper::OrderItem' do
    quantity { [*1..10].sample }
    product
    order
  end

end

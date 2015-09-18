FactoryGirl.define do
  factory :product, :class => 'Product' do
    title 'Hmhmhm'
    price { Faker::Commerce.price }
  end
end

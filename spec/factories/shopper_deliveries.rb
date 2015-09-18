FactoryGirl.define do
  factory :delivery, :class => 'Shopper::Delivery' do
    name { Faker::App.name }
    price { Faker::Commerce.price }
  end
end

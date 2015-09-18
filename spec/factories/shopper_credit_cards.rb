FactoryGirl.define do
  factory :credit_card, :class => 'Shopper::CreditCard' do
    number { Faker::Number.number(16) }
    expiration_month 3
    expiration_year { Time.now.year + 1 }
    cvv 123
  end
end

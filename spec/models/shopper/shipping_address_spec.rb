require 'rails_helper'

module Shopper
  RSpec.describe ShippingAddress, type: :model do
    it { expect(ShippingAddress.new.class.superclass).to eq(Address) }
  end
end

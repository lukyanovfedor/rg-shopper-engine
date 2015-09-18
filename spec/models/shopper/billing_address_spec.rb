require 'rails_helper'

module Shopper
  RSpec.describe BillingAddress, type: :model do
    it { expect(BillingAddress.new.class.superclass).to eq(Address) }
  end
end

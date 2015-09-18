require 'rails_helper'

module Shopper
  RSpec.describe ApplicationHelper, type: :helper do
    describe '#beauty_price' do
      it 'should format to two decimals after point' do
        expect(helper.beauty_price(1)).to eq('1.00')
      end
    end
  end
end

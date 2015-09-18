require 'rails_helper'

module Shopper
  RSpec.describe Address, type: :model do
    subject(:address) { FactoryGirl.create :address }

    describe 'Validation' do
      it { expect(address).to validate_presence_of(:first_name) }
      it { expect(address).to validate_presence_of(:last_name) }
      it { expect(address).to validate_presence_of(:country) }
      it { expect(address).to validate_presence_of(:city) }
      it { expect(address).to validate_presence_of(:street) }
      it { expect(address).to validate_presence_of(:phone) }
      it { expect(address).to validate_presence_of(:zip) }
      it { expect(address).to validate_presence_of(:country) }
      it { expect(address).to validate_numericality_of(:zip) }
      it { expect(address).to allow_value('+12314552').for(:phone) }
      it { expect(address).not_to allow_value('12314552').for(:phone) }
      it { expect(address).not_to allow_value('sadf').for(:phone) }
    end

    describe 'Associations' do
      it { expect(address).to belong_to(:country) }
      it { expect(address).to belong_to(:addressable) }
    end
  end
end

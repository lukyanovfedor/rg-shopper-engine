require 'rails_helper'

module Shopper
  RSpec.describe Country, type: :model do
    subject(:country) { FactoryGirl.create :country }

    describe 'Validation' do
      it { expect(country).to validate_presence_of(:name) }
      it { expect(country).to validate_uniqueness_of(:name).case_insensitive }
    end

    describe 'Before save' do
      it 'should capitalize #name' do
        country = FactoryGirl.create(:country, name: 'united states')
        expect(country.name).to eq 'United States'
      end
    end

    describe '#to_s' do
      it 'should return #name' do
        expect(country.to_s).to eq(country.name)
      end
    end
  end
end

module Shopper
  class Address < ActiveRecord::Base
    belongs_to :country
    belongs_to :addressable, polymorphic: true

    validates :first_name, :last_name, :street, :city, :zip, :phone, :country, presence: true
    validates :zip, numericality: true
    validates :phone, format: { with: /\A\+[\d]+\z/, message: :bad_phone }
  end
end
module Shopper
  class CreditCard < ActiveRecord::Base
    belongs_to :order

    validates :number, :expiration_month, :expiration_year, :cvv, presence: true
    validates :number, numericality: { only_integer: true }, length: { is: 16 }
    validates :cvv, numericality: { only_integer: true }, length: { is: 3 }
    validates :expiration_month, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12
    }
    validates :expiration_year, numericality: { only_integer: true }
    validate :valid_expiration_date

    def expiration_date
      "#{expiration_month} / #{expiration_year}"
    end

    def secure_number
      "**** **** **** #{self.number.scan(/.{4}/)[3]}"
    end

    private

    def valid_expiration_date
      unless errors[:expiration_year].empty? && errors[:expiration_month].empty?
        return
      end

      now = Date.today
      expire = Date.new(expiration_year, expiration_month, now.day)

      if expire < now
        errors.add(:expiration_date, 'can not be in past')
      end
    end
  end
end
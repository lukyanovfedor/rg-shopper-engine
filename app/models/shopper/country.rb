module Shopper
  class Country < ActiveRecord::Base
    validates :name, presence: true, uniqueness: { case_sensitive: false }

    before_save do
      self.name = self.name.split(' ').map(&:capitalize).join(' ')
    end

    def to_s
      name
    end
  end
end

class Product < ActiveRecord::Base
  register_as_product

  def to_s
    title
  end
end

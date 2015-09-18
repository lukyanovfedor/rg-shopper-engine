class CreateShopperDeliveries < ActiveRecord::Migration
  def change
    create_table :shopper_deliveries do |t|
      t.string :name, null: false
      t.float :price, null: false
      t.timestamps null: false
    end
  end
end

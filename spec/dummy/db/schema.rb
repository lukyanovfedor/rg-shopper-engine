# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150913110730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopper_addresses", force: :cascade do |t|
    t.string   "first_name",       null: false
    t.string   "last_name",        null: false
    t.string   "street",           null: false
    t.string   "city",             null: false
    t.string   "zip",              null: false
    t.string   "phone",            null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "type"
    t.integer  "country_id",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shopper_addresses", ["addressable_id", "addressable_type", "type"], name: "address_addressable_id_addressable_type_type", using: :btree
  add_index "shopper_addresses", ["country_id"], name: "index_shopper_addresses_on_country_id", using: :btree

  create_table "shopper_countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "shopper_countries", ["name"], name: "index_shopper_countries_on_name", unique: true, using: :btree

  create_table "shopper_credit_cards", force: :cascade do |t|
    t.string   "number",           null: false
    t.integer  "expiration_month", null: false
    t.integer  "expiration_year",  null: false
    t.integer  "cvv",              null: false
    t.integer  "order_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shopper_credit_cards", ["order_id"], name: "index_shopper_credit_cards_on_order_id", using: :btree

  create_table "shopper_deliveries", force: :cascade do |t|
    t.string   "name",       null: false
    t.float    "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopper_order_items", force: :cascade do |t|
    t.integer  "quantity",     null: false
    t.string   "product_type", null: false
    t.integer  "product_id",   null: false
    t.integer  "order_id",     null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "shopper_order_items", ["order_id"], name: "index_shopper_order_items_on_order_id", using: :btree
  add_index "shopper_order_items", ["product_type", "product_id"], name: "index_shopper_order_items_on_product_type_and_product_id", using: :btree

  create_table "shopper_orders", force: :cascade do |t|
    t.integer  "state",         null: false
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "delivery_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "shopper_orders", ["customer_id", "customer_type"], name: "index_shopper_orders_on_customer_id_and_customer_type", using: :btree
  add_index "shopper_orders", ["delivery_id"], name: "index_shopper_orders_on_delivery_id", using: :btree
  add_index "shopper_orders", ["state"], name: "index_shopper_orders_on_state", using: :btree

end

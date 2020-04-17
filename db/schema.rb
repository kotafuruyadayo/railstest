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

ActiveRecord::Schema.define(version: 2020_03_26_043041) do

  create_table "depo_main_edit", id: false, force: :cascade do |t|
    t.text "field1"
    t.text "field2"
    t.text "field3"
    t.text "field4"
    t.text "field5"
    t.text "field6"
    t.integer "field7"
    t.integer "field8"
    t.integer "field9"
    t.integer "field10"
    t.text "field11"
    t.text "field12"
    t.integer "field13"
    t.integer "field14"
    t.text "field15"
    t.text "field16"
    t.text "field17"
    t.text "field18"
    t.integer "field19"
    t.text "field20"
    t.integer "field21"
    t.integer "field22"
    t.integer "field23"
    t.integer "field24"
    t.integer "field25"
    t.integer "field26"
    t.text "field27"
    t.text "field28"
    t.text "field29"
    t.text "field30"
    t.text "field31"
    t.text "field32"
    t.text "field33"
    t.integer "field34"
    t.text "field35"
    t.text "field36"
    t.text "field37"
    t.text "field38"
    t.text "field39"
    t.text "field40"
  end

  create_table "depologins_BK", force: :cascade do |t|
    t.string "user_id"
    t.string "password"
    t.string "authority"
    t.datetime "access_date"
    t.datetime "insert_date"
    t.datetime "update_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "depomains", force: :cascade do |t|
    t.string "depo_cd"
    t.string "seikei_num"
    t.string "delivery_name1"
    t.string "delivery_address1"
    t.string "send_name1"
    t.string "send_address1"
    t.integer "shipment_cnt"
    t.string "shipment_date"
    t.string "arrival_date"
    t.string "item_cd"
    t.string "serial_num"
    t.string "product_name"
    t.string "status"
    t.string "section_code"
    t.string "section_name1"
    t.string "section_name2"
    t.string "remarks_factory"
    t.string "sales_name"
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "keep_division"
    t.string "depo_arrival_date"
    t.string "depo_shipment_date"
    t.integer "keep_day"
    t.integer "over_day"
    t.integer "depo_shipment_cnt"
    t.string "delivery_trader"
    t.string "delivery_charge"
    t.string "delivery_car"
    t.string "delivery_name2"
    t.string "delivery_address2"
    t.string "remarks_depo"
    t.string "packing_type"
    t.integer "fee_point"
    t.datetime "insert_date"
    t.string "insert_id"
    t.string "insert_ap"
    t.datetime "update_date"
    t.string "update_id"
    t.string "update_ap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "depomains_BK", force: :cascade do |t|
    t.string "depo_cd"
    t.string "seikei_num"
    t.string "delivery_name1"
    t.string "delivery_address1"
    t.string "send_name1"
    t.string "send_address1"
    t.integer "shipment_cnt"
    t.string "shipment_date"
    t.string "arrival_date"
    t.string "item_cd"
    t.string "serial_num"
    t.string "product_name"
    t.string "status"
    t.string "section_code"
    t.string "section_name1"
    t.string "section_name2"
    t.string "remarks_factory"
    t.string "sales_name"
    t.string "carrier_cod"
    t.string "carrier_name"
    t.string "keep_division"
    t.string "depo_arrival_date"
    t.string "depo_shipment_date"
    t.integer "keep_day"
    t.integer "over_day"
    t.integer "depo_shipment_cnt"
    t.string "delivery_trader"
    t.string "delivery_charge"
    t.string "delivery_car"
    t.string "delivery_name2"
    t.string "delivery_address2"
    t.string "remarks_depo"
    t.string "packing_type"
    t.integer "fee_point"
    t.datetime "insert_date"
    t.string "insert_id"
    t.string "insert_ap"
    t.datetime "update_date"
    t.string "update_id"
    t.string "update_ap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "depomsts", force: :cascade do |t|
    t.integer "mst_type"
    t.integer "mst_id"
    t.string "mst_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "authority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

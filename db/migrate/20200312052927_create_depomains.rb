class CreateDepomains < ActiveRecord::Migration[5.2]
  def change
    create_table :depomains do |t|

      t.string :depo_cd 
      t.string :seikei_num 
      t.string :delivery_name1 
      t.string :delivery_address1 
      t.string :send_name1 
      t.string :send_address1 
      t.integer :shipment_cnt 
      t.string :shipment_date 
      t.string :arrival_date 
      t.string :item_cd 
      t.string :serial_num 
      t.string :product_name 
      t.string :status 
      t.string :section_code 
      t.string :section_name1 
      t.string :section_name2 
      t.string :remarks_factory 
      t.string :sales_name 
      t.string :carrier_code
      t.string :carrier_name 
      t.string :keep_division 
      t.string :depo_arrival_date 
      t.string :depo_shipment_date 
      t.integer :keep_day 
      t.integer :over_day 
      t.integer :depo_shipment_cnt
      t.string :delivery_trader 
      t.string :delivery_charge 
      t.string :delivery_car 
      t.string :delivery_name2 
      t.string :delivery_address2 
      t.string :remarks_depo 
      t.string :packing_type 
      t.integer :fee_point 
      t.datetime :insert_date
      t.string :insert_id 
      t.string :insert_ap 
      t.datetime :update_date
      t.string :update_id 
      t.string :update_ap 
      t.timestamps
    end
  end
end

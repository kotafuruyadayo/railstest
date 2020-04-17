class CreateDepomsts < ActiveRecord::Migration[5.2]
  def change
    create_table :depomsts do |t|

      t.integer :mst_type
      t.integer :mst_id 
      t.string :mst_cd 

      t.timestamps
    end
  end
end

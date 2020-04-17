class CreateDepologins < ActiveRecord::Migration[5.2]
  def change
    create_table :depologins do |t|
      t.string :user_id
      t.string :password
      t.string :authority
      t.datetime :access_date
      t.datetime :insert_date
      t.datetime :update_date
      t.timestamps
    end
  end
end

class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :wave_customer_id

      t.references :company

      t.timestamps
    end
  end
end

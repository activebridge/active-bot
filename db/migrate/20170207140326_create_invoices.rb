class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.integer :hours
      t.references :customer
      t.references :user

      t.timestamps
    end
  end
end

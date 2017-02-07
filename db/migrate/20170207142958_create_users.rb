class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :slack_name
      t.string :status
      t.references :company

      t.timestamps
    end
  end
end

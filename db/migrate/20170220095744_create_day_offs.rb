class CreateDayOffs < ActiveRecord::Migration[5.0]
  def change
    create_table :day_offs do |t|
      t.date :date
      t.references :company, foreign_key: true
      t.references :user

      t.timestamps
    end
  end
end

class AddDeletedRoleToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :deleted, :boolean, default: false
    add_column :users, :role, :string
  end
end

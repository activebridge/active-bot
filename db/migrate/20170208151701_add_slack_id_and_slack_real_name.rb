class AddSlackIdAndSlackRealName < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :slack_id, :string
  end
end

class AddSlackTeamIdToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :slack_team_id, :string
  end
end

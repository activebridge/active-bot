# frozen_string_literal: true
desc 'Create a invoces for each user on waveapp'
task get_users_from_slack: :environment do
  if Date.today == Date.last_business_day_for_current_month
    # Robot is running
  end
end

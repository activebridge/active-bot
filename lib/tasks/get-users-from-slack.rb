# frozen_string_literal: true
desc 'Get a list of users from a slack'
task get_users_from_slack: :environment do
  if Date.today == Date.last_business_day_for_current_month
    # Robot is running
  end
end

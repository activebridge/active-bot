# frozen_string_literal: true
desc 'Create a invoces for each user on waveapp'
task waveapps_push_hours: :environment do
  if Date.today == Date.last_business_day_for_current_month
    # Robot is running
  end
end

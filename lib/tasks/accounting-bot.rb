# frozen_string_literal: true
desc 'Bot track the time of each user on a project for a month'
task accounting_bot: :environment do # should run once in a months (last business day)
  if Date.today == Date.last_business_day_for_current_month
    # Robot is running
  end
end

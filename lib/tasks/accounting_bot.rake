# frozen_string_literal: true
desc 'Bot track the time of each user on a project for a month'
task accounting_bot: :environment do # should run once in a months (last business day)
  if Date.today == Date.last_business_day_for_current_month
    client = Slack::Client.new

    # TODO: remove scope where(slack_id: 'U041S94UP'), send only to me
    User.active.developers.where(slack_id: 'U041S94UP').each do |user|
      result = client.im_open(user: user.slack_id)
      channel_id = result['channel']['id']

      options = { channel_id: channel_id, customer_name: user.last_customer_name, hours: user.current_month_working_hours }
      message = SlackDialogMessage.full_time(options)
      client.chat_postMessage(message)
    end
  end
end

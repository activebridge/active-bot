# frozen_string_literal: true
desc 'Get a list of users from a slack'
task get_users_from_slack: :environment do
  if Date.today == Date.last_business_day_for_current_month
    token = ENV['SLACK_TOKEN']
    client = Slack::Client.new token: token

    active_bridge = Company.default

    slack_users = client.users_list['members']
    slack_users.each do |slack_user|
      attributes = {
        name: slack_user['real_name'],
        slack_name: slack_user['name'],
        slack_id: slack_user['id'],
        status: slack_user['status'],
        company: active_bridge
      }

      user = User.find_or_initialize_by(slack_id: slack_user['id'])
      user.update_attributes attributes
    end
  end
end

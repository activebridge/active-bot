# frozen_string_literal: true
class SlacksController < ApplicationController
  def check_project

    client = Slack::Client.new
    result = client.im_open(user: 'U041S94UP') # D43ETBNQJ
    #channel_id = 'D43ETBNQJ'
    channel_id = result['channel']['id']

    actions = []
    Customer.find_in_batches(batch_size: 5) do |group|
      group_array = []
      group.each do |customer|
        group_array << {
          name: 'project',
          text: customer.name,
          type: 'button',
          value: customer.id
        }
      end

      actions << group_array
    end

    attachments = []
    attachments << {
      text: 'CHANGED',
      fallback: 'You are not able to check the project.',
      callback_id: 'checked_project',
      color: 'good',
      attachment_type: 'default',
      actions: actions.first
    }

    # default, primary, danger
    options = {
      channel: channel_id,
      text: 'Hello world',
      as_user: true,
      attachments: attachments.to_json
    }

    #client.chat_postMessage(options)

    #render json: 'test_post_button', status: 200

    render json: options, status: 200
  end

  # params["payload"]
  #=> "{\"actions\":[{\"name\":\"game\",\"value\":\"chess\"}],\"callback_id\":\"wopr_game\",\"team\":{\"id\":\"T040ZA47T\",\"domain\":\"activebridge\"},\"channel\":{\"id\":\"D43ETBNQJ\",\"name\":\"directmessage\"},\"user\":{\"id\":\"U041S94UP\",\"name\":\"igorvbilan\"},\"action_ts\":\"1486719017.443926\",\"message_ts\":\"1486672682.000002\",\"attachment_id\":\"1\",\"token\":\"fDDhLgv52Aad17VpO8VSIxYC\",\"original_message\":{\"type\":\"message\",\"user\":\"U43HBJ7CM\",\"text\":\"Hello world\",\"bot_id\":\"B43H0UKJ8\",\"attachments\":[{\"callback_id\":\"wopr_game\",\"fallback\":\"You are unable to choose a game\",\"text\":\"Choose a game to play\",\"id\":1,\"color\":\"3AA3E3\",\"actions\":[{\"id\":\"1\",\"name\":\"game\",\"text\":\"Chess\",\"type\":\"button\",\"value\":\"chess\",\"style\":\"\"},{\"id\":\"2\",\"name\":\"game\",\"text\":\"Falken's Maze\",\"type\":\"button\",\"value\":\"maze\",\"style\":\"\"},{\"id\":\"3\",\"name\":\"game\",\"text\":\"Thermonuclear War\",\"type\":\"button\",\"value\":\"war\",\"style\":\"danger\",\"confirm\":{\"text\":\"Wouldn't you prefer a good game of chess?\",\"title\":\"Are you sure?\",\"ok_text\":\"Yes\",\"dismiss_text\":\"No\"}}]}],\"ts\":\"1486672682.000002\"},\"response_url\":\"https:\\/\\/hooks.slack.com\\/actions\\/T040ZA47T\\/139821698724\\/cpvMk8NTsFthjbe8db2e0ZUT\"}"
  #
  # r=JSON.parse(params['payload'])
  # r.keys
  #=> ["actions", "callback_id", "team", "channel", "user", "action_ts", "message_ts", "attachment_id", "token", "original_message", "response_url"]
end

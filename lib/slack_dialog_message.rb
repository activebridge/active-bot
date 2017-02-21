class SlackDialogMessage
  class << self
    def full_time(params)
      actions = [
        {
          name: 'full_time',
          text: 'Yes',
          style: 'primary',
          type: 'button',
          value: 'yes'
        },
        {
          name: 'full_time',
          text: 'No',
          type: 'button',
          value: 'no'
        }
      ]

      attachments = [
        {
          text: "#{params[:hours]} hours",
          fallback: 'You are not able to set full time.',
          callback_id: 'full_time',
          color: 'good',
          attachment_type: 'default',
          actions: actions
        }
      ]

      options = {
        channel: params[:channel_id],
        text: "Have you been working full time for #{params[:customer_name]} customer this month?",
        as_user: true,
        attachments: attachments.to_json
      }

      options
    end

    def other_project(channel_id)
      actions = [
        {
          name: 'other_project',
          text: 'Yes',
          type: 'button',
          value: 'yes'
        },
        {
          name: 'other_project',
          text: 'No',
          style: 'primary',
          type: 'button',
          value: 'no'
        }
      ]

      attachments = [
        {
          text: 'you would like to track?',
          fallback: 'You are not able to set other projects.',
          callback_id: 'other_project',
          color: '#439FE0',
          attachment_type: 'default',
          actions: actions
        }
      ]

      options = {
        channel: channel_id,
        text: "Any other project ...",
        as_user: true,
        attachments: attachments.to_json
      }

      options
    end

    def general(params = {})
      options = {
        channel: params[:channel_id],
        text: params[:text],
        as_user: true
      }

      options
    end

    # Message will be edit by slack hook
    # no need attachments.to_json here
    # more details, please review SlackApi.update_message
    def done(params = {})
      options = {
        channel: params[:channel_id],
        text: params[:text],
        as_user: true,
        attachments: [
          {
            text: "Thank you, my dear #{params[:user_name]}. :wink:",
            color: 'good'
          }
        ]
      }

      options
    end

    def choose_project(channel_id)
      actions = []
      # batch_size is 5: limit for slack interactive buttons
      Customer.find_in_batches(batch_size: 5) do |group|
        group_array = []
        group.each do |customer|
          group_array << {
            name: 'customer',
            text: customer.name,
            type: 'button',
            value: customer.id
          }
        end

        actions << group_array
      end

      attachments = []
      actions.each_with_index  do |action, index|
        attachments << {
          text: '',
          fallback: 'You are not able to check the project.',
          callback_id: 'choose_project',
          color: '#439FE0',
          attachment_type: 'default',
          actions: action
        }
      end

      options = {
        channel: channel_id,
        text: 'Please, select your customer:',
        as_user: true,
        attachments: attachments
      }

      options
    end

    def insert_hours(params = {})
      options = {
        channel: params[:channel_id],
        text: "How many hours you did you work for #{params[:customer_name]}?",
        attachments: [],
        as_user: true
      }

      options
    end
  end
end

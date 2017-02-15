# frozen_string_literal: true
class SlacksController < ApplicationController
  after_action :replace_original_message, only: :check_project

  def check_project
    head :ok
  end

  def replace_original_message
    hours = 164

    message = case message_params[:callback_id]
              when 'full_time'
                if value == 'yes'
                  Invoice.create(customer: customer, user: user, hours: hours)

                  # FINAL step
                  text = "#{customer.name}: #{hours} hours."
                  full_time_params = { text: text, user_name: user.name, channel_id: channel_id }
                  SlackDialogMessage.done(full_time_params)
                  # TODO:: close the chat
                  # TODO:: post to Alexandr
                else
                  SlackDialogMessage.choose_project(channel_id)
                end
              when 'choose_project'
                Invoice.create(customer: customer, user: user)

                insert_hours_params = { customer_name: customer.name, channel_id: channel_id }
                SlackDialogMessage.insert_hours(insert_hours_params)
              when 'other_project'
                if value == 'yes'
                  SlackDialogMessage.choose_project(channel_id)
                else
                  # FINAL step
                  text = "#{customer.name}: #{hours} hours."
                  full_time_params = { text: text, user_name: user.name, channel_id: channel_id }
                  SlackDialogMessage.done(full_time_params)
                  # TODO:: close the chat
                  # TODO:: post to Alexandr
                end
              else
                { text: 'Somethig was wrong. Please, let us know. ActiveBridge LLC.' }
              end

    SlackApi.update_message replace_params.merge(message: message)
  end

  private

  def customer
    return Customer.find(value) if choose_project?
    user.last_customer
  end

  def user
    @user ||= User.find_by(slack_id: message_params.dig(:user, :id))
  end

  def channel_id
    @channel_id ||= message_params.dig(:channel, :id)
  end

  def value
    message_params[:actions].first[:value]
  end

  def message_params
    @message_params ||= JSON.parse(params['payload'], symbolize_names: true)
  end

  def replace_params
    {
      response_url: message_params[:response_url],
      message_ts: message_params[:message_ts]
    }
  end

  def choose_project?
    message_params[:callback_id] == 'choose_project'
  end
end

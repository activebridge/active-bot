# frozen_string_literal: true
class SlacksController < ApplicationController
  after_action :replace_original_message, only: :check_project

  def check_project
    head :ok
  end

  def replace_original_message
    message = case message_params[:callback_id]
              when 'full_time'
                if value == 'yes'
                  Invoice.create(customer: customer, user: user, hours: 164)
                  send_to_accountent
                  generate_final_message
                  # TODO:: close_the_chat_with_user
                else
                  SlackDialogMessage.choose_project(channel_id)
                end
              when 'choose_project'
                Invoice.create(customer: customer, user: user)

                puts insert_hours_params = { customer_name: customer.name, channel_id: channel_id }
                SlackDialogMessage.insert_hours(insert_hours_params)
              when 'other_project'
                if value == 'yes'
                  SlackDialogMessage.choose_project(channel_id)
                else
                  send_to_accountent
                  generate_final_message
                  # TODO:: close_the_chat_with_user
                end
              else
                { text: 'Somethig was wrong. Please, let us know. ActiveBridge LLC.' }
              end

    SlackApi.update_message replace_params.merge(message: message)
  end

  private

  def generate_final_message
    full_time_params = { text: final_text_message, user_name: user.name, channel_id: channel_id }
    SlackDialogMessage.done(full_time_params)
  end

  def final_text_message
    user = User.active.developers.where(slack_id: 'U041S94UP').first
    current_month_invoices = user.invoices.this_months.includes(:customer)
    text = ''
    current_month_invoices.each do |invoice|
      text += " • #{invoice.customer_name}: #{invoice.hours} hours. \n"
    end

    text
  end

  def current_month_invoices
    user.invoices.this_months.includes(:customer)
  end

  def send_to_accountent
    result = client.im_open(user: User.accountant.slack_id)
    channel_id = result['channel']['id']

    text = "*#{user.name}* (slack_id: _#{user.slack_name}_):\n" + final_text_message
    options = { channel_id: channel_id, text: text }
    message = SlackDialogMessage.accountant(options)
    client.chat_postMessage(message)
  end

  def close_the_chat_with_user
    client.im_close(channel: channel_id)
  end

  def client
    @client ||= Slack::Client.new
  end

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

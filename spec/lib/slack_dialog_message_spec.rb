# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SlackDialogMessage do
  let(:channel_id) { 'channelID' }
  let(:text) { 'textOtext' }
  let(:user_name) { 'user_0_name' }
  let(:customer_name) { 'customer_0_name' }
  let(:hours) { 164 }

  describe '#full_time' do
    let(:params) { {channel_id: channel_id, hours: hours, customer_name: customer_name} }
    let(:options) {
      {
        channel: channel_id,
        text: "Have you been working full time for #{customer_name} customer this month?",
        as_user: true,
        attachments: [
          {
            text: "#{hours} hours",
            fallback: 'You are not able to set full time.',
            callback_id: 'full_time',
            color: 'good',
            attachment_type: 'default',
            actions: [
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
          }
        ].to_json
      }
    }
    it { expect(SlackDialogMessage.full_time(params)).to eq options  }
  end

  describe '#other_project' do
    let(:options) {
      {
        channel: channel_id,
        text: "Any other project ...",
        as_user: true,
        attachments: [
          {
            text: 'you would like to track?',
            fallback: 'You are not able to set other projects.',
            callback_id: 'other_project',
            color: '#439FE0',
            attachment_type: 'default',
            actions: [
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
          }
        ].to_json
      }
    }
    it { expect(SlackDialogMessage.other_project(channel_id)).to eq options  }
  end

  describe '#accountant' do
    let(:params) { {channel_id: channel_id, text: text} }
    let(:options) {
      {
        channel: channel_id,
        text: text,
        as_user: true
      }
    }
    it { expect(SlackDialogMessage.accountant(params)).to eq options  }
  end

  describe '#done' do
    let(:params) { {channel_id: channel_id, text: text, user_name: user_name} }
    let(:options) {
      {
        channel: channel_id,
        text: text,
        as_user: true,
        attachments: [
          {
            text: "Thank you, my dear #{user_name}. :wink:",
            color: 'good'
          }
        ]
      }
    }
    it { expect(SlackDialogMessage.done(params)).to eq options  }
  end

  describe '#choose_project' do
    let!(:customers) { create_list(:customer, 7) }
    let(:options) {
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
    }

    it { expect(SlackDialogMessage.choose_project(channel_id)).to eq options  }
  end

  describe '#insert_hours' do
    let(:params) { {channel_id: channel_id, customer_name: customer_name } }
    let(:options) {
      {
        channel: channel_id,
        text: "How many hours you did you work for #{customer_name}?",
        attachments: [],
        as_user: true
      }
    }
    it { expect(SlackDialogMessage.insert_hours(params)).to eq options  }
  end

end

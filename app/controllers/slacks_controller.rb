# frozen_string_literal: true
class SlacksController < ApplicationController
  after_action :replace_original_message, only: :check_project, if: :replace_message?

  def check_project
    head :ok
  end

  private

  def replace_original_message
    Bot::OriginalMessage.new(options).replace
  end

  def options
    {
      user: user,
      channel_id: channel_id,
      slack_params: slack_params
    }
  end

  def user
    company.users.find_by(slack_id: slack_params.dig(:user, :id))
  end

  def company
    Company.find_by(slack_team_id: slack_params.dig(:team, :id))
  end

  def channel_id
    @channel_id ||= slack_params.dig(:channel, :id)
  end

  def slack_params
    @slack_params ||= JSON.parse(params['payload'], symbolize_names: true)
  end

  def replace_message?
    params.key?('payload')
  end
end

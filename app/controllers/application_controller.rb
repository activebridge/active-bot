# frozen_string_literal: true
class ApplicationController < ActionController::API
  def default
    render json: 'Welcome to Active Accounting Bot.', status: 200
  end
end

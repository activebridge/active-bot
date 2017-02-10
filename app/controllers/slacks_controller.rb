# frozen_string_literal: true
class SlacksController < ApplicationController
  def check_project
    render json: 'test_post_button', status: 200
  end
end

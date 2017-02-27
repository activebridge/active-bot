# frozen_string_literal: true
# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

Thread.abort_on_exception = false
Thread.new do
  Bot::SlackRealtime.run
end

run Rails.application

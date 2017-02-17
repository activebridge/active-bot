# frozen_string_literal: true
# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative 'lib/slack_realtime'

Thread.abort_on_exception = true
Thread.new do
  SlackRealtime.run
end

run Rails.application

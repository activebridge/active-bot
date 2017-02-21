# frozen_string_literal: true
# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# require_relative 'lib/slack_realtime'
# require_relative 'lib/slack_dialog_message'
# Dir.glob('./lib/slack/**/*.rb').each { |file| require file }

Thread.abort_on_exception = false
Thread.new do
  SlackRealtime.run
end

run Rails.application

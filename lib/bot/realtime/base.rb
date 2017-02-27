# frozen_string_literal: true
module Bot
  module Realtime
    class Base
      attr_reader :company, :channel_id, :value

      def initialize(params = {})
        @company = params[:company]
        @channel_id = params[:channel_id]
        @value = params[:value]
      end

      private

      def notify(text)
        message.text = text
        message.extend(Bot::Messages::General)
        Bot::Api.post_message(message: message.generate)
      end

      def message
        @message ||= Bot::Message.new(channel_id: channel_id)
      end
    end
  end
end

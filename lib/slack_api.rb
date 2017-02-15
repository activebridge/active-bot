class SlackApi
  class << self
    def update_message(options = {})
      response_url = options[:response_url]
      message = options[:message]

      # INFO:: you can respond to a user's command up to
      # 5 times within 30 minutes of the command's invocation.
      response = replace_message(response_url, message)

      unless response.code == 200
        # https://api.slack.com/docs/messages
        # attachments HTTP parameter that accepts a URL-encoded string of a JSON hash
        attachments = message[:attachments].to_json

        client = Slack::Client.new
        client.chat_update(message.merge(ts: options[:message_ts], attachments: attachments))
      end
    end

    def replace_message(response_url, message)
      uri = URI.parse(response_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.path)
      request.add_field('Content-Type', 'application/json')
      request.body = message.to_json
      response = http.request(request)
    end
  end

end

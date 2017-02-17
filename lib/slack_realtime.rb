class SlackRealtime
  def self.run
    client = Slack::Client.new
    realtime_client = client.realtime

    realtime_client.on :hello do
      Rails.logger.info 'LETS GO SlackRealtime =======>>>'
    end

    realtime_client.on :message do |params|
      message = params['text']

      if message.to_i > 0
        user = User.find_by(slack_id: params['user'])
        last_invoice = user.invoices.last
        if last_invoice.hours.nil?
          last_invoice.update_attributes(hours: message.to_i)

          message = SlackDialogMessage.other_project(params['channel'])
          client = Slack::Client.new
          client.chat_postMessage(message)
        end
      end
    end

    realtime_client.start # listen a STREAM
  end

end

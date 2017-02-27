# frozen_string_literal: true
module Bot
  class SlackRealtime
    def self.run
      client = Slack::Client.new
      realtime_client = client.realtime

      realtime_client.on :hello do
        Rails.logger.info 'LETS GO SlackRealtime =======>>>'
      end

      realtime_client.on :message do |params|
        company = Company.find_by(slack_team_id: params['team'])

        if company
          user = company.users.find_by(slack_id: params['user'])
          slack_message = params['text']

          # TODO: refactor (use class with roles)
          if user&.admin? || user&.accountant?
            # class_names: customer, dayoff
            # methods: list, add, delete
            class_name, method, value = slack_message.split

            object = "Bot::Realtime::#{class_name.capitalize}".safe_constantize
            #byebug

            if object && object.instance_methods(false).include?(method.to_sym)
              realtime_params = { company: company, channel_id: params['channel'], value: value }
              object.new(realtime_params).send(method)
            end
          elsif user&.developer?
            case slack_message
            when /dayoff list/
              Bot::Realtime::DayOff.new(company: company, channel_id: params['channel']).list
            else
              if slack_message.to_i.positive?
                last_invoice = user.invoices.last
                if last_invoice && last_invoice.hours.nil?
                  last_invoice.update_attributes(hours: slack_message.to_i)

                  message = Bot::Message.new(channel_id: params['channel'])
                  message.extend(Bot::Messages::OtherProject)
                  Bot::Api.post_message(message: message.generate)
                end
              end
            end

          end
        end

      end

      realtime_client.start # listen a STREAM
    end
  end
end

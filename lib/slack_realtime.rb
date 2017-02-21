# frozen_string_literal: true
class SlackRealtime
  def self.run
    client = Slack::Client.new
    realtime_client = client.realtime

    realtime_client.on :hello do
      Rails.logger.info 'LETS GO SlackRealtime =======>>>'
    end

    realtime_client.on :message do |params|
      Rails.logger.info params
      slack_message = params['text']
      slack_channel = params['channel']

      company = Company.find_by(slack_team_id: params['team'])
      user = company.users.find_by(slack_id: params['user'])

      # TODO: !!! refactor the code
      if user.developer?
        # TODO: day off for developer
        if slack_message.to_i.positive?
          last_invoice = user.invoices.last
          if last_invoice && last_invoice.hours.nil?
            last_invoice.update_attributes(hours: slack_message.to_i)

            new_message = SlackDialogMessage.other_project(slack_channel)
            client.chat_postMessage(new_message)
          end
        end
      else
        # Admin OR Accountant (not a developer)
        text = case slack_message
               when /customer list/
                 company.customers.map(&:name).join("\n")
               when /customer add/
                 customer_name = slack_message.match('(?<=customer add ).+')[0]
                 company.customers << Customer.find_or_create_by(name: customer_name)
                 "Customer #{customer_name} has been created."
               when /customer delete/
                 customer_name = slack_message.match('(?<=customer delete ).+')[0]
                 company.customers.where(name: customer_name).delete_all
                 "Customer #{customer_name} has been deleted."
               when /dayoff list/
                 company.day_offs.map(&:date).join("\n")
               when /dayoff add/
                 # TODO: convert into the date
                 day_off = slack_message.match('(?<=dayoff add ).+')[0]
                 company.day_offs << DayOff.find_or_create_by(date: convert_to_date(day_off))
                 "Day Off #{day_off} has been created."
               when /dayoff delete/
                 # TODO: convert into the date
                 day_off = slack_message.match('(?<=dayoff delete ).+')[0]
                 company.day_offs.where(date: convert_to_date(day_off)).delete_all
                 "Day Off #{day_off} has been deleted."
               end

        if text.present?
          options = { text: text, channel_id: slack_channel }
          new_message = SlackDialogMessage.general(options)
          client.chat_postMessage(new_message)
        end
      end
    end

    realtime_client.start # listen a STREAM
  end

  def self.convert_to_date(a_string)
    Date.parse(a_string)
  rescue
    Date.today + 1.day
  end
end

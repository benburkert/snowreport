require 'sinatra/base'
require 'rack/client'
require 'json'

class SnowReport < Sinatra::Base
  report_url = "http://www.epicmix.com/vailresorts/sites/epicmix/api/mobile/weather.ashx"

  get '/' do
    client = Rack::Client.new

    response = client.get(report_url)

    if response.status == 200
      conditions = JSON.parse(response.body)["snowconditions"].first

      message_for(conditions)
    else
      status 500
    end
  end

  helpers do
    def message_for(conditions)
      message = "#{conditions['newSnow']}\" of new snow today\n"
      message << "#{conditions['last48Hours']}\" of new snow in the last two days\n"
      message << "#{conditions['last7Days']}\" of new snow in the last week\n"
      message << "#{conditions['midMountainBase']}' mountain base\n\n"

      message << conditions['weatherForecast'].map {|data| forcast(data) }.join("\n")

      message
    end

    def forcast(data)
      message = "Forcast for #{data['dayDescription']}:\n"
      message << data['forecastString'] << "\n"
      message << "tl;dr: high #{data['temperatureHigh']}, low #{data['temperatureLow']}, #{data['summaryDescription']}\n"

      message
    end
  end
end

run SnowReport.new

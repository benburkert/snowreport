require 'sinatra/base'
require 'rack/client'
require 'nokogiri'

class SnowReport < Sinatra::Base
  heavenly_url = 'http://www.skiheavenly.com/the-mountain/snow-report/snow-report.aspx'

  get '/' do
    client = Rack::Client.new

    response = client.get(heavenly_url)

    if response.status == 200
      doc = Nokogiri::HTML(response.body)

      doc.css(".introText span").first.content.strip
    else
      status 500
    end
  end
end

run SnowReport.new

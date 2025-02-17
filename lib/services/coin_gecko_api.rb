require 'json'
require 'net/http'

class CoinGeckoApi
	BASE_URL = ENV['COIN_GECKO_API_URL']
	API_TOKEN = ENV['COIN_GECKO_API_TOKEN']

	def initialize
    @uri = URI(BASE_URL)
    @headers = {
      'Authorization' => "Bearer #{API_TOKEN}",
      'Content-Type' => 'application/json'
    }
  end

  def get(endpoint)
    uri = URI.join(@uri, endpoint)
    request = Net::HTTP::Get.new(uri, @headers)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  end
end
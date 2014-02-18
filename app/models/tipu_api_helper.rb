require 'net/http'
require 'active_support/cache/memory_store'

class TipuApiHelper
    def self.GetMunicipalities
      if Rails.cache.read('municipalitiesdropdown').nil?
          puts 'Refreshing municipalities cache'
          @municipalities = JSON.parse GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/municipalities?format=json"))
          @municipalities = @municipalities["municipalities"]["municipality"]
          Rails.cache.write('municipalitiesdropdown', @municipalities, :expires_in => 30.minutes)
      end
      return Rails.cache.read('municipalitiesdropdown')
    end


    def self.GetApiData(uri)
      req = ::Net::HTTP::Get.new(uri)
      req.basic_auth Lintuvaara::ApiConfig::SERVER_ACCOUNT, Lintuvaara::ApiConfig::SERVER_PASSWORD
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|  # Ignore ssl cert errors for dev...
        https.request(req)
      end
      return res.body
    end

    def self.GetRingerById(ringer_id)
      JSON.parse GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers/#{ringer_id}?format=json"))
    end
end
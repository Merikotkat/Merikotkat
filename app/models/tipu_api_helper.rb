require 'net/http'

class TipuApiHelper
  def self.GetMunicipalities
    uri = URI("https://h92.it.helsinki.fi/tipu-api/municipalities?format=json")
    req = ::Net::HTTP::Get.new(uri)
    req.basic_auth Lintuvaara::ApiConfig::SERVER_ACCOUNT, Lintuvaara::ApiConfig::SERVER_PASSWORD
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|  # Ignore ssl cert errors for dev...
      https.request(req)
    end

    @municipalities = JSON.parse res.body
    @municipalities = @municipalities["municipalities"]["municipality"]
  end
end
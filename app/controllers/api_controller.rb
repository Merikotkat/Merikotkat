require 'net/http'

class ApiController < ApplicationController
  def getringer
    uri = URI("https://h92.it.helsinki.fi/tipu-api/ringers?format=json&filter=#{params['filter']}")
    req = ::Net::HTTP::Get.new(uri)
    req.basic_auth Lintuvaara::ApiConfig::SERVER_ACCOUNT, Lintuvaara::ApiConfig::SERVER_PASSWORD
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|  # Ignore ssl cert errors for dev...
      https.request(req)
    end

    respond_to do |format|
        format.json { render json: res.body}
    end
  end
end

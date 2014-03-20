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
      #todo remove before production! SRIZLY!
      if ringer_id == "admin_linssitest"
        return {"ringers"=>{"ringer"=>{"id"=>"admin_linssitest", "mobile-phone"=>"", "recovery-letter-method"=>"paper", "yearofbirth"=>"", "email"=>"", "address"=>{"street"=>"", "postcode"=>"", "city"=>""}, "name"=>"Hurrdurr", "permit"=>{"codes"=>"", "year"=>""}, "lastname"=>"AHO", "permission"=>0, "firstname"=>"MATTI", "language"=>"fi"}}}
      end

      JSON.parse GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers/#{ringer_id}?format=json"))
    end


    def self.GetSpecies
      if Rails.cache.read('tipuapispecies').nil?
        puts 'Refreshing species cache'
        species = JSON.parse GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/species?format=json"))

        Rails.cache.write('tipuapispecies', species['species'], :expires_in => 30.minutes)
      end
      return Rails.cache.read('tipuapispecies')
    end
end
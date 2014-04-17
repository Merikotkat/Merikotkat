require 'net/http'
require 'active_support/cache/memory_store'

class TipuApiHelper
    def self.GetApiData(uri)
      req = ::Net::HTTP::Get.new(uri)
      req.basic_auth Lintuvaara::ApiConfig::SERVER_ACCOUNT, Lintuvaara::ApiConfig::SERVER_PASSWORD
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|  # Ignore ssl cert errors for dev...
        https.request(req)
      end
      return res.body
    end


    def self.GetApiDataFromCache(uri)
      if Rails.cache.read(uri).nil?
        puts 'Refreshing cache for uri: ' + uri
        data = JSON.parse GetApiData(URI(uri))

        Rails.cache.write(uri, data, :expires_in => 2.hours)
      end
      return Rails.cache.read(uri)
    end


    def self.GetRingerById(ringer_id)
      #todo remove before production! SRIZLY!
      if ringer_id == "admin_linssitest"
        return {"ringers"=>{"ringer"=>{"id"=>"admin_linssitest", "mobile-phone"=>"", "recovery-letter-method"=>"paper", "yearofbirth"=>"", "email"=>"", "address"=>{"street"=>"", "postcode"=>"", "city"=>""}, "name"=>"Hurrdurr", "permit"=>{"codes"=>"", "year"=>""}, "lastname"=>"AHO", "permission"=>0, "firstname"=>"MATTI", "language"=>"fi"}}}
      end

      JSON.parse GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers/#{ringer_id}?format=json"))
    end


    def self.GetSpecies
      data = GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/species?format=json");
      return data['species']
    end


    def self.GetGenders
      return GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/codes/9?format=json");
    end


    def self.GetMunicipalities
      data = GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/municipalities?format=json");
      return data["municipalities"]["municipality"]
    end


    def self.GetShyness
      return GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/codes/801?format=json");
    end


    def self.GetRingColors
      return GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/codes/303?format=json");
    end


    def self.GetGenderDeterminationMethod
      return GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/codes/10?format=json");
    end

    def self.GetRingedStatus
      return {"codes"=>
                  {"code"=>[
                      {"id"=>1, "desc"=>[{"content"=>"Kyllä", "lang"=>"FI"}, {"content"=>"Ja", "lang"=>"SV"}, {"content"=>"Yes", "lang"=>"EN"}]},
                      {"id"=>0, "desc"=>[{"content"=>"Ei", "lang"=>"FI"}, {"content"=>"Nej", "lang"=>"SV"}, {"content"=>"No", "lang"=>"EN"}]},
                      {"id"=>-1, "desc"=>[{"content"=>"Ei tietoa", "lang"=>"FI"}, {"content"=>"Okänd", "lang"=>"SV"}, {"content"=>"Not known", "lang"=>"EN"}]}
                  ]}}
    end

    def self.GetColors
      return GetApiDataFromCache("https://h92.it.helsinki.fi/tipu-api/codes/303?format=json");
    end
end
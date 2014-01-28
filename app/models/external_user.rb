class ExternalUser < ActiveResource::Base
  include KoalaClient::ExternalUser
  self.site     = Lintuvaara::ApiConfig::SERVER_API_ADDRESS
  self.user     = Lintuvaara::ApiConfig::SERVER_ACCOUNT
  self.password = Lintuvaara::ApiConfig::SERVER_PASSWORD
end
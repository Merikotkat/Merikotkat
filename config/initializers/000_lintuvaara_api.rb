module Lintuvaara
  
  # HTTP API Configuration for Active Resource
  module ApiConfig
  
    # Defaults
    api_account                = "linssi-dev" #todo change username
    api_password               = "devlinssi" #todo change password
    lintuvaara_api_proto       = 'https://'
    lintuvaara_api_host        = 'lintuvaara.ihku.fi'
    lintuvaara_api_uri         = "/api"
    lintuvaara_auth_uri        = "/sessions"
    lintuvaara_preferences_uri = "/user_preferences"
    lintuvaara_logout_uri      = "/sessions/logout"
    lintuvaara_service_name    = "linssi_localhost" #todo change this to avoid redirect loops :p  "linssi_localhost" for localhost "linssi" for production

    
    ### No configuration below this point ###
    #              
    SERVER_HOST       = lintuvaara_api_host
    API_URI           = lintuvaara_api_uri
    AUTH_URI          = lintuvaara_auth_uri
    PREFERENCES_URI   = lintuvaara_preferences_uri
    LOGOUT_URI        = lintuvaara_logout_uri
    SERVER_ACCOUNT    = api_account
    SERVER_PASSWORD   = api_password
    SERVER_PROTOCOL   = lintuvaara_api_proto
    SERVER_SERVICE_NAME = lintuvaara_service_name
    
    SERVER_BASE_URL        = "#{SERVER_PROTOCOL}#{SERVER_HOST}"
    SERVER_API_ADDRESS     = "#{SERVER_BASE_URL}#{API_URI}"
    SERVER_AUTH_ADDRESS    = "#{SERVER_BASE_URL}#{AUTH_URI}"
    SERVER_PUBLIC_ADDRESS  = SERVER_BASE_URL
    SERVER_PREFERENCES_URL = "#{SERVER_BASE_URL}#{PREFERENCES_URI}"
    SERVER_LOGOUT_URL      = "#{SERVER_BASE_URL}#{LOGOUT_URI}"

  end
  
end
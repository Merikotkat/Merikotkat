require_relative '../../../lib/koala_client/authentication_token'
require_relative '../../../lib/koala_client/external_authentication'
require 'net/http'

class KoalaClient::ExternalAuthenticationController < ApplicationController
  
  skip_before_filter :authentication_required
  skip_before_filter :update_session_expiry

  def new
    begin
      key = CGI::escape params['key']
      iv = CGI::escape params['iv']
      data = CGI::escape params['data']

      uri = URI("https://h92.it.helsinki.fi/tipu-api/lintuvaara-authentication-decryptor?key=#{key}&iv=#{iv}&data=#{data}")
      req = ::Net::HTTP::Get.new(uri)
      req.basic_auth Lintuvaara::ApiConfig::SERVER_ACCOUNT, Lintuvaara::ApiConfig::SERVER_PASSWORD
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|  # Ignore ssl cert errors for dev...
        https.request(req)
      end

      user = KoalaClient::ExternalAuthentication.new(res.body)
    rescue
      flash[:warning] = I18n.t('flash.service_login_failed')
      redirect_to failed_external_authentication_url and return
    end

    # Authenticated!
    session[:user] = user.login_id
    session[:user_type] = user.login_type
    session[:user_name] = user.name
    
    # Redirect to index or do we have a specific URI from Lintuvaara
    if params[:service_uri].blank?
      #redirect_to (user.login_type == "admin" ? admin_index_url : user_index_url)
      redirect_to KoalaClient.configuration.auth_success_url
    else
      service_uri_with_locale = add_locale_param_to_uri(params[:service_uri], params[:locale])
      redirect_to service_uri_with_locale
    end

  end

  # Failed logins
  def failed
    render(&:html)
  end

  ## TODO: Remove route
  # def index
  #   redirect_to admin_index_url
  # end

  def logout
    reset_session
    #todo fix this locale adding thingy...
    #lintuvaara_logout_url = add_locale_param_to_uri(KoalaClient.configuration.server_logout_url, I18n.locale)
    redirect_to Lintuvaara::ApiConfig::SERVER_LOGOUT_URL
  end

  protected

  # Adds locale parameter to the service uri unless it already has locale parameter.
  # 1) /kihla/admin/poolfiles/list?type=A
  #    -->  /kihla/admin/poolfiles/list?type=A&locale=LOCALE
  # 2) /kihla/admin/poolfiles
  #    -->  /kihla/admin/poolfiles?locale=LOCALE
  # 3) /kihla/admin/poolfiles?locale=XX
  #    --> /kihla/admin/poolfiles?locale=XX
  def add_locale_param_to_uri(uri, locale)
    if uri.include? 'locale='
      return uri
    end
    
    if uri.include? '?'
      return uri + "&locale=#{locale}"
    else
      return uri + "?locale=#{locale}"
    end
  end

end

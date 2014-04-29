class ApplicationController < ActionController::Base
  if Rails.env.test?
    before_filter :mock_usr
  else
    include KoalaClient::Authentication
    before_filter :update_session_expiry
    before_filter :authentication_required
  end

  before_action :set_locale

  if Rails.env.production?
    rescue_from Exception, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  def render_404
    respond_to do |format|
      format.html { render template: '404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end



  def mock_usr
    session = { :user => '1', :user_type => 'admin', :user_name => 'Pekka Murkka'}
    @user = {:login_id => session[:user], :type => session[:user_type], :user_name => session[:user_name]}
  end


  def set_locale
    if !params[:locale].nil?
      cookies[:user_locale] = { value: params[:locale].downcase, expires: 1.year.from_now }
    end
    I18n.locale = cookies[:user_locale]
  end

  helper_method :get_userlocaleforapi
  def get_userlocaleforapi
    if !cookies[:user_locale].nil?
      return "EN" if cookies[:user_locale] == "en"
      return "FI" if cookies[:user_locale] == "fi"
    end

    return "FI"
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def access_granted?
    session[:user]
  end

  def correct_user_type?
    ["rengastaja", "maallikko", "rengastuskeskus", "admin"].include?(session[:user_type])
  end

  def set_user_variable
    @user = {:login_id => session[:user], :type => session[:user_type], :user_name => session[:user_name]}
  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
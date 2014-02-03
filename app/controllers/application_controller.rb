class ApplicationController < ActionController::Base
  include KoalaClient::Authentication
  before_filter :authentication_required
  before_filter :update_session_expiry

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def access_granted?
    session[:user]
  end

  def correct_user_type?
    ["rengastaja", "maallikko", "rengastuskeskus"].include?(session[:user_type])
  end

  def set_user_variable
    @user = {:login_id => session[:user], :type => session[:user_type]}
  end
end
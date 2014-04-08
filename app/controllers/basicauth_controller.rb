class BasicauthController < ApplicationController
  skip_before_filter :authentication_required
  skip_before_filter :update_session_expiry

  #todo use db or config file for authentication?
  http_basic_authenticate_with name: "hurrdurr", password: "herpderp"
end
class ExternalApisController < ApplicationController
  respond_to :json

  def index
  #todo add authentication and parameters
    render json: VisitationForm.all

  end


end
class ExternalApisController < BasicauthController
  respond_to :json

  def index
  #todo add authentication and parameters
    render json: VisitationForm.all

  end


end
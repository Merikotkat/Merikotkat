class ExternalApisController < BasicauthController
  respond_to :json

  def index
  #todo add authentication and parameters
    render json: VisitationForm.all

  end

  def getimageurls
    #todo json format? required fields? hurr?
    images = Image.where "visitation_form_id = ?",  params[:id]
    hurr = images.to_json(:only => [ :id, :filename, :category_id ])
    render json: hurr
  end
end
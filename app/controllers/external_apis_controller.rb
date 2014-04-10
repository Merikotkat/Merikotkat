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


  def getvisitationforms
    #todo define fields and format
    nestid = params[:nestid]
    speciesid = params[:speciesid]
    datefrom = params[:datefrom]
    dateto = params[:dateto]

    forms = VisitationForm.where(nest_id: nestid).where(species_id: speciesid).where(visit_date: datefrom..dateto)
    render json: forms.to_json
  end
end

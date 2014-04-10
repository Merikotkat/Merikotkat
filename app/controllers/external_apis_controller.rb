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

    forms = VisitationForm.all
    forms = forms.where(nest_id: nestid) unless nestid.nil?
    forms = forms.where(species_id: speciesid) unless speciesid.nil?
    forms = forms.where(visit_date: datefrom..dateto) unless datefrom.nil? || dateto.nil?

    render json: forms.to_json(:include => [:birds, { :images => { :except => [ :data, :thumbnaildata ]}}])
  end
end

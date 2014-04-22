class ExternalApisController < BasicauthController
  respond_to :json

  def index
    render json: VisitationForm.all
  end


  def getvisitationforms
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

  def getimage
    image = Image.find(params[:id])
    send_data image.data, type: image.content_type, filename: image.filename, disposition: 'inline'
  end
end

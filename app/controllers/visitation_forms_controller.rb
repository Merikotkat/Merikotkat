class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy, :submit_form, :unsubmit_form]
  before_action :check_permission, except: [:index, :new, :create]

  if Rails.env.test?
    before_action :set_municipalities_api_test
  else
    before_action :set_municipalities_api_prod
  end

  def set_municipalities_api_prod
    @municipalities = TipuApiHelper.GetMunicipalities
  end
  def set_municipalities_api_test
    @municipalities = TipuApiHelperMock.GetMunicipalities
  end


  def check_permission
    if @user[:type] != 'admin' && @visitation_form.form_saver_id != @user[:login_id] && @visitation_form.photographer_id != @user[:login_id]
      puts 'No permission, return 404'
      not_found
    end
  end


  # GET /visitation_forms
  # GET /visitation_forms.json
  def index

    if @user[:type] == 'admin'
      forms = VisitationForm.all
    else
      forms = VisitationForm.where("form_saver_id = ? or photographer_id = ?", @user[:login_id],@user[:login_id])
    end

    if (defined? params[:type] and !params[:type].nil?)
      @header = t(params[:type])
      @type = params[:type]
      if(params[:type] == "submitted")
        @visitation_forms = forms.select { |f| f.sent == true }
      elsif (params[:type] == "unsubmitted")
        @visitation_forms = forms.select { |f| f.sent != true }
      end
    else
      @header = t('forms')
      @visitation_forms = forms
    end
  end

  # GET /visitation_forms/1
  # GET /visitation_forms/1.json
  def show
    @bird1_images = Image.get_bird1_images(params[:id])
    @bird2_images = Image.get_bird2_images(params[:id])
    @young_images = Image.get_young_images(params[:id])
    @landscape_images = Image.get_landscape_images(params[:id])
    @nest_images = Image.get_nest_images(params[:id])
  end

  # GET /visitation_forms/new
  def new
    @uuid = SecureRandom.uuid
    @visitation_form = VisitationForm.new
  end

  # GET /visitation_forms/1/edit
  def edit
    @uuid = SecureRandom.uuid
    @bird1_images = Image.get_bird1_images(params[:id])
    @bird2_images = Image.get_bird2_images(params[:id])
    @young_images = Image.get_young_images(params[:id])
    @landscape_images = Image.get_landscape_images(params[:id])
    @nest_images = Image.get_nest_images(params[:id])

  end

  # POST /visitation_forms
  # POST /visitation_forms.json
  def create
    @visitation_form = VisitationForm.new(visitation_form_params)
    @visitation_form.form_saver_id = @user[:login_id]

    save_form
  end

  # PATCH/PUT /visitation_forms/1
  # PATCH/PUT /visitation_forms/1.json
  def update
    @visitation_form.attributes = visitation_form_params

   save_form
  end

  def save_form
    @visitation_form.sent = false

    # first save without validation
    if @visitation_form.save :validate => false
      # upload images now that our form has an ID
      attach_images params[:visitation_form][:uuid], @visitation_form.id

      # then save again with validation if needed. Beautiful!
      if @visitation_form.save :validate => params[:save].nil?
        # and lastly, mark form as 'sent' if needed
        if params[:submit]
          @visitation_form.sent = true
          # look, another save!
          @visitation_form.save
        end

        redirect_to @visitation_form
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def attach_images(uuid, formId)
    images = Image.where "upload_id = ?", uuid

    images.each do |img|
      img.visitation_form_id = formId
      img.upload_id = NIL
      img.save
    end

  end

  def submit_form
    @visitation_form.sent = true
    if @visitation_form.save
      redirect_to @visitation_form
    else
      render action: 'edit'
    end
  end

  def unsubmit_form
    @visitation_form.sent = false
    @visitation_form.save validate: false
    redirect_to @visitation_form
  end


  # DELETE /visitation_forms/1
  # DELETE /visitation_forms/1.json
  def destroy
    @visitation_form.destroy
    respond_to do |format|
      format.html { redirect_to visitation_forms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visitation_form
      @visitation_form = VisitationForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visitation_form_params
      params.require(:visitation_form).permit(:photographer_name, :visit_date, :camera, :lens, :teleconverter, :municipality, :nest, :nest_id, :photographer_id, :form_saver_id)
    end
end

class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy, :submit_form, :unsubmit_form, :approve_form]
  before_action :check_permission, except: [:index, :new, :create]

  #todo maybe move this to form save instead? Although the necessary variables are not present there.. hmm
  after_action :updateauditlog, except: [:index, :new, :show, :edit]

  if Rails.env.test?
    before_action :set_municipalities_api_test
  else
    before_action :set_municipalities_api_prod
  end

  def set_municipalities_api_prod
    @municipalities = TipuApiHelper.GetMunicipalities
    @species = TipuApiHelper.GetSpecies
  end
  def set_municipalities_api_test
    @municipalities = TipuApiHelperMock.GetMunicipalities
    @species = TipuApiHelperMock.GetSpecies
  end


  def user_has_access_to_form form
    form.owners.each do |owner|
      return true if owner.owner_id == @user[:login_id]
    end

    return true if form.photographer_id == @user[:login_id]

    return false
  end

  # GET /visitation_forms
  # GET /visitation_forms.json
  def index
    puts AuditLogEntry.all.inspect
    #if @user[:type] == 'admin'
    #  forms = VisitationForm.all
    #else
    #  forms = VisitationForm.where("form_saver_id = ? or photographer_id = ?", @user[:login_id],@user[:login_id])
    #end

    # Find the forms the user has access to
    forms = Array.new
    VisitationForm.find_each do |form|
      if @user[:type] == 'admin'
        # Admin has access to all forms
        forms.push form
      else
        forms.push(form) if user_has_access_to_form form
      end
    end

    # Filter the forms
    if (defined? params[:type] and !params[:type].nil?)
      @header = t(params[:type])
      @type = params[:type]
      if(params[:type] == "submitted")
        @visitation_forms = forms.select { |f| f.sent == true && f.approved != true }
      elsif (params[:type] == "unsubmitted")
        @visitation_forms = forms.select { |f| f.sent != true && f.approved != true }
      elsif(params[:type] == "archive")
        if @user[:type] == 'admin'
          @visitation_forms = forms.select { |f| f.approved == true }
        else
          not_found
        end
      end
    else
      #default?
      @visitation_forms = forms.select { |f| f.sent != true }
      #not_found
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
    @visitation_form.species_id = 'HALALB'  # set merikotka as default...
  end

  # GET /visitation_forms/1/edit
  def edit
    if @visitation_form.approved
      redirect_to @visitation_form
    else
      @uuid = SecureRandom.uuid
      @bird1_images = Image.get_bird1_images(params[:id])
      @bird2_images = Image.get_bird2_images(params[:id])
      @young_images = Image.get_young_images(params[:id])
      @landscape_images = Image.get_landscape_images(params[:id])
      @nest_images = Image.get_nest_images(params[:id])
    end
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

    destroy_deleted_images

    # first save without validation
    if @visitation_form.save :validate => false
      # upload images now that our form has an ID
      attach_images params[:visitation_form][:uuid], @visitation_form.id
      add_owners params[:owners], @visitation_form.id

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

  def approve_form
    if @user[:type] == 'admin'
      @visitation_form.sent = true
      @visitation_form.approved = true
      @visitation_form.save :validate => false
    end

    redirect_to @visitation_form
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
    if @visitation_form.images.count > 0
      flash[:notice] = I18n.t('form_has_images')
      redirect_to @visitation_form
      return
    end

    @visitation_form.destroy
    respond_to do |format|
      format.html { redirect_to action: 'index', :type => "unsubmitted" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def check_permission
    if @user[:type] == 'admin'
      return
    else
    permission = false
    @visitation_form.owners.each do |owner|
      if @user[:login_id] == owner.owner_id
        permission = true
        break
      end
    end

    if !permission
      # puts 'No permission, return 404'
      not_found
    end

    end
  end


  def updateauditlog
    entry = AuditLogEntry.new
    entry.timestamp = Time.now
    entry.userid = @user[:login_id]
    entry.username = @user[:user_name]
    entry.visitation_form_id = @visitation_form.id
    entry.operation = action_name
    entry.save
  end


  def set_visitation_form
    @visitation_form = VisitationForm.find(params[:id])
  end

  def add_owners(owner_array,formId)
    owners = Owner.where("visitation_form_id= ?", formId).destroy_all

    owner_array.each do |owner_info|
      owner = Owner.new
      owner.owner_name=owner_info[:name]
      owner.owner_id=owner_info[:id]
      owner.visitation_form_id=formId
      owner.save
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

  def destroy_deleted_images
    if params[:deleted_images] != nil
      params[:deleted_images].each do |img_id|
        Image.find(img_id).destroy
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitation_form_params
    params.require(:visitation_form).permit(:photographer_name, :visit_date, :camera, :lens, :teleconverter, :municipality, :nest, :nest_id, :photographer_id, :form_saver_id, :species_id)
  end
end

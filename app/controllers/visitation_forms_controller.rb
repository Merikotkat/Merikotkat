class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy, :submit_form, :unsubmit_form, :approve_form]
  before_action :check_permission, except: [:index, :new, :create]
  after_action :update_audit_log, except: [:index, :new, :show, :edit]
  before_action :set_municipalities_api

  def set_municipalities_api
    if Rails.env.test?
      @municipalities = TipuApiHelperMock.GetMunicipalities
      @species = TipuApiHelperMock.GetSpecies
    else
      @municipalities = TipuApiHelper.GetMunicipalities
      @species = TipuApiHelper.GetSpecies
    end
  end




  # GET /visitation_forms
  # GET /visitation_forms.json
  def index
    # Filter the forms
    if (defined? params[:type] and !params[:type].nil?)
      @header = t(params[:type])
      @type = params[:type]

      if ((defined? params[:sortby] and !params[:sortby].nil?) and defined? params[:order] and !params[:order].nil?)
        @sortby_order = "&sortby=" + params[:sortby] + "&order=" + params[:order]
      else
        @sortby_order = ""
        params[:sortby] = nil
        params[:order] = nil
      end


      if (@visitation_forms = VisitationForm.get_forms_of_type @user, params[:type], params[:sortby], params[:order]) == false
        not_found
      end
    else
      @visitation_forms = Array.new
    end

    @total_visitation_forms = @visitation_forms.count

    @per_page = 5

    if (not defined? params[:page] or params[:page].nil?)
      @visitation_forms = @visitation_forms.first(@per_page)
    else
      start_index = (params[:page].to_i - 1) * @per_page
      end_index = start_index + @per_page - 1
      @visitation_forms = @visitation_forms[start_index..end_index]
    end
  end

  # GET /visitation_forms/1
  # GET /visitation_forms/1.json
  def show
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

    @visitation_form.approved = false if @visitation_form.approved == nil

    destroy_deleted_images

    # first save without validation
    if @visitation_form.save :validate => false
      # upload images now that our form has an ID
      add_birds params[:birds], @visitation_form
      attach_images params[:visitation_form][:uuid], @visitation_form
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
      redirect_to @visitation_form and return
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
    unless user_has_access_to_form @visitation_form
      not_found
    end
  end

  def user_has_access_to_form form
    return true if @user[:type] == 'admin'

    form.owners.each do |owner|
      return true if owner.owner_id == @user[:login_id]
    end

    return true if form.photographer_id == @user[:login_id]

    return false
  end

  def update_audit_log
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

  def add_birds(bird_array, form)
    for i in form.birds.count...bird_array.count do
      bird = Bird.new
      bird.shyness = bird_array[i][:shyness]
      bird.gender = bird_array[i][:gender]
      bird.visitation_form_id = form.id
      bird.save
    end
  end

  def add_owners(owner_array,formId)
    Owner.where("visitation_form_id= ?", formId).destroy_all
    owner_array.each do |owner_info|
      owner = Owner.new
      owner.owner_name=owner_info[:name]
      owner.owner_id=owner_info[:id]
      owner.visitation_form_id=formId
      owner.save
    end
  end

  def attach_images(uuid, form)
    images = Image.where "upload_id = ?", uuid
    images.each do |img|
      img.visitation_form_id = form.id
      img.upload_id = NIL
      img.save
    end

    i = 0
    form.birds.each do |bird|
      images.select { |img| img.temp_index == i }.each do |image|
        image.bird_id = bird.id
        image.save
      end
      i += 1
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

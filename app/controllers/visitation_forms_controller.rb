class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy]

  # GET /visitation_forms
  # GET /visitation_forms.json
  def index
    #puts 'logged on user: ' + session[:user]  # debug stuff


    if @user[:type] == 'admin'
      forms = VisitationForm.all
    else
      forms = VisitationForm.where("form_saver_id = ? or photographer_id = ?", @user[:login_id],@user[:login_id])
    end
    if (defined? params[:type])
      if(params[:type] == "submitted")
        @visitation_forms = forms.select { |f| f.sent == true }
      elsif (params[:type] == "unsubmitted")
        @visitation_forms = forms.select { |f| f.sent == false }
      end
    else
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
    @visitation_form = VisitationForm.new
  end

  # GET /visitation_forms/1/edit
  def edit
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
    # first save without validation
    if @visitation_form.save :validate => false
      # upload images now that our form has an ID
      upload_images @visitation_form.id

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

  def submit_form
    @visitation_form = VisitationForm.find(params[:id])
    @visitation_form.sent = true
    if @visitation_form.save
      redirect_to @visitation_form
    else
      render action: 'edit'
    end
  end

  def unsubmit_form
    form = VisitationForm.find(params[:id])
    form.sent = false
    form.save validate: false
    redirect_to form
  end

  def upload_images(form_id)
    # Bird 1
    unless params[:visitation_form][:images][:bird1].nil?
      params[:visitation_form][:images][:bird1].each do |name, data|
        img = Image.new
        img.visitation_form_id = form_id
        img.gender = params[:visitation_form][:images][:bird1_info][:gender]
        img.filename = data.original_filename
        img.data = data.read

        img.image_type = 1

        img.save
      end
    end

    # Bird 2
    unless params[:visitation_form][:images][:bird2].nil?
      params[:visitation_form][:images][:bird2].each do |name, data|
        img = Image.new
        img.visitation_form_id = form_id
        img.gender = params[:visitation_form][:images][:bird2_info][:gender]
        img.filename = data.original_filename
        img.data = data.read

        img.image_type = 2

        img.save
      end
    end

    # Young birds
    unless params[:visitation_form][:images][:young].nil?
      params[:visitation_form][:images][:young].each do |name, data|
        img = Image.new
        img.visitation_form_id = form_id
        img.filename = data.original_filename
        img.data = data.read

        img.image_type = 3

        img.save
      end
    end

    # Landscape
    unless params[:visitation_form][:images][:landscape].nil?
      params[:visitation_form][:images][:landscape].each do |name, data|
        img = Image.new
        img.visitation_form_id = form_id
        img.filename = data.original_filename
        img.data = data.read

        img.image_type = 4

        img.save
      end
    end

    # Nest
    unless params[:visitation_form][:images][:nest].nil?
      params[:visitation_form][:images][:nest].each do |name, data|
        img = Image.new
        img.visitation_form_id = form_id
        img.filename = data.original_filename
        img.data = data.read

        img.image_type = 5

        img.save
      end
    end
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

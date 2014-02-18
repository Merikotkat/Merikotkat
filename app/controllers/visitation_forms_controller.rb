class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy]

  # GET /visitation_forms
  # GET /visitation_forms.json
  def index
    #puts 'logged on user: ' + session[:user]  # debug stuff
    @visitation_forms = VisitationForm.all
  end

  # GET /visitation_forms/1
  # GET /visitation_forms/1.json
  def show
    @images = Image.get_images(params[:id])
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

    if params[:submit]
      @visitation_form.sent = true
      if @visitation_form.save
        redirect_to @visitation_form
      else
        render action: 'new'
      end
    end

    if params[:save]
      if @visitation_form.save :validate => false
        redirect_to @visitation_form
      else
        render action: 'new'
      end
    end
  end

  # PATCH/PUT /visitation_forms/1
  # PATCH/PUT /visitation_forms/1.json
  def update
    if params[:submit]
      @visitation_form.sent = true
      if @visitation_form.save
        redirect_to @visitation_form
      else
        render action: 'new'
      end
    end

    if params[:save]
      if @visitation_form.save :validate => false
        redirect_to @visitation_form
      else
        render action: 'new'
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

  def upload_image
    img = Image.new
    img.visitation_form_id = params[:id]
    img.filename = params[:file].original_filename
    img.data = params[:file].read

    img.save

    redirect_to visitation_form_path(params[:id])
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

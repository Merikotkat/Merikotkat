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
      # upload image now that our form has an ID
      upload_image @visitation_form.id

      # then save again with validation if needed. Beautiful!
      if @visitation_form.save :validate => params[:save].nil?
        # and lastly, mark form as 'sent' if needed
        if params[:submit]
          send_form @visitation_form
        end

        redirect_to @visitation_form
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def send_form(form)
    form.sent = true
    form.save
  end

  def upload_image(form_id)
    if params[:visitation_form][:file].nil?
      return
    end

    img = Image.new
    img.visitation_form_id = form_id
    img.filename = params[:visitation_form][:file].original_filename
    img.data = params[:visitation_form][:file].read

    img.save
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

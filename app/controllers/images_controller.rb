class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :delete, :thumbnail]
  before_action :check_permission, except: [:new, :create]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  def show
      send_data @image.data, type: @image.content_type, filename: @image.filename, disposition: 'inline'
  end

  # GET /images/thumbnail/1
  def thumbnail
    send_data @image.thumbnaildata, type: @image.content_type, filename: @image.filename, disposition: 'inline'
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @results = []

    unless params[:files].nil?
      params[:files].each do |data|
        img = Image.new
        img.filename = data.original_filename
        img.data = data.read
        img.upload_id = params[:uuid]
        img.visitation_form_id = params[:formId]
        img.image_type = params[:imageType]
        img.content_type = data.content_type
        #img.temp_index = params[:birdIndex]
        img.bird_id = params[:birdId]

        if !img.save
          render :json => { :errors => img.errors.full_messages }, :status => 400 and return
        else
          @results <<  { name: img.filename, imageType: img.image_type, id: img.id }
        end
      end
    end

    render json: { files: @results }
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def delete
    if !@image.visitation_form_id.nil?
      form = VisitationForm.find(@image.visitation_form_id)
      @image.destroy unless form.approved
      render json: {status: "ok" } and return
    elsif !params[:uuid].nil? && params[:uuid] == @image.upload_id
      @image.destroy
      render json: {status: "ok" } and return
    end
    render json: { errors: 'Could not delete image' }, status: 400 and return
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:filename)
  end

  def check_permission
    @visitation_form = VisitationForm.where("id = ?", @image.visitation_form_id).take

    # If form is nil, the image isn't attached to a form yet (i.e. it has just been uploaded)
    return true if @visitation_form.nil?

    @visitation_form.owners.each do |owner|
      return true if owner.owner_id == @user[:login_id]
    end

    if @user[:type] != 'admin' && @visitation_form.photographer_id != @user[:login_id]
      puts 'No permission, return 404'
      not_found
    end
  end
end

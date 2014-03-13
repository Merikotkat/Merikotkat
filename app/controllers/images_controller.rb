
class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :delete]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
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
    #todo fix this shit
    @filename
    @imagetype



    unless params[:files].nil?
      params[:files].each do |data|
        img = Image.new
        img.filename = data.original_filename
        img.data = data.read
        img.upload_id = params[:uuid]
        img.image_type = param[:imageType]
        img.content_type = data.content_type

        #todo fix this shit
        @filename = img.filename
        @imagetype = img.image_type

        if !img.save
          render :json => { :errors => img.errors.full_messages }, :status => 400 and return
        end
      end
    end

    render json: {files: [
        {
            name: @filename,
            imageType: @imagetype
        }]
    }

    #size: 902604,
    #url: "http:\/\/example.org\/files\/picture1.jpg",
    #thumbnailUrl: "http:\/\/example.org\/files\/thumbnail\/picture1.jpg",
    #deleteUrl: "http:\/\/example.org\/files\/picture1.jpg",
    #deleteType: "DELETE"

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

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    form_id = @image.visitation_form_id
    @image.destroy
    redirect_to visitation_form_path(form_id)
  end

  def delete
    form_id = @image.visitation_form_id
    @image.destroy
    redirect_to visitation_form_path(form_id)
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
end

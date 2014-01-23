class VisitationFormsController < ApplicationController
  before_action :set_visitation_form, only: [:show, :edit, :update, :destroy]

  # GET /visitation_forms
  # GET /visitation_forms.json
  def index
    @visitation_forms = VisitationForm.all
  end

  # GET /visitation_forms/1
  # GET /visitation_forms/1.json
  def show
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

    respond_to do |format|
      if @visitation_form.save
        format.html { redirect_to @visitation_form, notice: 'Visitation form was successfully created.' }
        format.json { render action: 'show', status: :created, location: @visitation_form }
      else
        format.html { render action: 'new' }
        format.json { render json: @visitation_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visitation_forms/1
  # PATCH/PUT /visitation_forms/1.json
  def update
    respond_to do |format|
      if @visitation_form.update(visitation_form_params)
        format.html { redirect_to @visitation_form, notice: 'Visitation form was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visitation_form.errors, status: :unprocessable_entity }
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
      params.require(:visitation_form).permit(:photographer_name, :visit_date)
    end
end

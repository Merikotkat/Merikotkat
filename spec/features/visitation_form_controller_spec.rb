require 'spec_helper'
require 'byebug'

# Use 1010 or 2890 for valid photographer/saver ids


describe VisitationForm do

  it "admin can see all forms" do
    user = { login_id: '1', user_name: 'Pekka Murkka', type: 'admin'}

    form = visitationform
    form2 = visitationform

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    tulos = testi.index

    expect(tulos.count).to be(2)



  end

  it "user can't see all forms" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}

    form = visitationform
    form2 = visitationform

    form2.photographer_id=1010
    form2.form_saver_id=1010
    form.photographer_id=1010
    form.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)

    tulos = testi.index

    expect(tulos.count).to be(0)

  end

  it "user can see own forms" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}

    form = visitationform
    form2 = visitationform

    form.photographer_id=1010
    form.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    tulos = testi.index

    expect(tulos.count).to be(1)

  end

  it "user can see own forms with photographer id" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}

    form = visitationform
    form2 = visitationform

    form.photographer_id=1010
    form.form_saver_id=1010

    form2.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    tulos = testi.index

    expect(tulos.count).to be(1)

  end

  it "user can see own forms with saver id" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}

    form = visitationform
    form2 = visitationform

    form.photographer_id=1010
    form.form_saver_id=1010

    form2.photographer_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    tulos = testi.index

    expect(tulos.count).to be(1)

  end


  def visitationform
    formi = VisitationForm.new
    formi.save(:validate => false)
    formi.photographer_name = "Pekka Murkka"
    formi.visit_date = "2014-01-01"
    formi.camera = "Super Internal Cam"
    formi.lens = "Lens Man 2000"
    formi.teleconverter =  "TC Teleconv"
    formi.municipality = "HELSIN"
    formi.nest = "Roni's nest for children"
    formi.nest_id = 268
    formi.photographer_id = 2890
    formi.form_saver_id = 2890
    formi.images << Image.create
    formi.save
    return formi

  end

end
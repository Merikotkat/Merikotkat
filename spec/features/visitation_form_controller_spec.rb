require 'spec_helper'
require 'byebug'
require_relative 'visitationform_factory'

# Use 1010 or 2890 for valid photographer/saver ids


describe VisitationForm do

  it "admin can see all forms" do
    user = { login_id: '1', user_name: 'Pekka Murkka', type: 'admin'}
    params = { type: 'unsubmitted', page: 1, per_page: 20 }

    form = Visitationform_factory.GetValidVisitationForm
    form2 = Visitationform_factory.GetValidVisitationForm

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    testi.params = params


    tulos = testi.index

    expect(tulos.count).to be(2)

  end

  it "user can't see all forms" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}
    params = { type: 'unsubmitted', page: 1, per_page: 20 }

    form = Visitationform_factory.GetValidVisitationForm
    form2 = Visitationform_factory.GetValidVisitationForm

    form2.photographer_id=1010
    form2.form_saver_id=1010
    form.photographer_id=1010
    form.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    testi.params = params

    tulos = testi.index

    expect(tulos.count).to be(0)

  end

  it "user can see own forms" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}
    params = { type: 'unsubmitted', page: 1, per_page: 20 }

    form = Visitationform_factory.GetValidVisitationForm
    form2 = Visitationform_factory.GetValidVisitationForm

    form.photographer_id=1010
    form.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    testi.params = params

    tulos = testi.index

    expect(tulos.count).to be(1)

  end

  it "user can see own forms with photographer id" do
    user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}
    params = { type: 'unsubmitted', page: 1, per_page: 20 }

    form = Visitationform_factory.GetValidVisitationForm
    form2 = Visitationform_factory.GetValidVisitationForm

    form.photographer_id=1010
    form.form_saver_id=1010

    form2.form_saver_id=1010

    form.save
    form2.save

    testi = VisitationFormsController.new
    testi.instance_variable_set(:@user, user)
    testi.params = params

    tulos = testi.index

    expect(tulos.count).to be(1)

  end

  #it "user can see own forms with saver id" do
  #  user = { login_id: '2890', user_name: 'Pekka Murkka', type: 'rengastaja'}
  #
  #  form = Visitationform_factory.GetValidVisitationForm
  #  form2 = Visitationform_factory.GetValidVisitationForm
  #
  #  form.photographer_id=1010
  #  form.form_saver_id=1010
  #
  #  form2.photographer_id=1010
  #
  #  form.save
  #  form2.save
  #
  #  testi = VisitationFormsController.new
  #  testi.instance_variable_set(:@user, user)
  #  tulos = testi.index
  #
  #  expect(tulos.count).to be(1)
  #
  #end
end
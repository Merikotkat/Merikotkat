require 'spec_helper'
require 'byebug'

describe VisitationForm do

  it "is not saved to database if not valid" do
    vf = VisitationForm.create

    expect(vf.valid?).to be(false)
    expect(VisitationForm.count).to eq(0)

    vf = VisitationForm.create municipality:"HARHALALLAA"

    expect(vf.valid?).to be(false)
    expect(VisitationForm.count).to eq(0)

    vf = VisitationForm.create municipality:"HELSINKI"

    expect(vf.valid?).to be(false)
    expect(VisitationForm.count).to eq(0)
  end

  it "is saved to database if valid" do
    formitesti = visitationform
    expect(formitesti).to be_valid

  end


  def visitationform
  formi = VisitationForm.new
  formi.save(:validate => false)
  formi.photographer_name = "Pekka Murkka"
  formi.visit_date = DateTime.new(2013, 6, 29, 10, 15, 30)
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
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

  it "Municipality is invalid" do
    formitesti = visitationform
    formitesti.municipality="gigigigigi"
    expect(formitesti.valid?).to be(false)
  end


  it "Date invalid" do
    formitesti = visitationform
    formitesti.visit_date = '2013-02-31'
    expect(formitesti.valid?).to be(false)
  end

  it "Date not in future" do
    formitesti = visitationform
    formitesti.visit_date = DateTime.now - 10.days
    expect(formitesti).to be_valid
  end

  it "Date in future" do
    formitesti = visitationform
    formitesti.visit_date = DateTime.now + 1.days
    expect(formitesti.valid?).to be(false)
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

    image = Image.new
    image.data = SecureRandom.uuid  # Create random image to prevent md5sum from failing all tests
    formi.images << image

    formi.save
    return formi

  end

end
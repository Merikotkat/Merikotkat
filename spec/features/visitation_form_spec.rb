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
    im = FactoryGirl.create(:image)
    byebug
    vf = FactoryGirl.create(:visitation_form)
    raise
    vf << im

    expect(vf).to be_valid
    expect(VisitationForm.count).to eq(1)
  end

end
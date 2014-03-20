require 'spec_helper'
require 'byebug'
require_relative 'visitationform_factory'

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

  it "is not saved to database if species id not valid" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    formitesti.species_id = "HARHALALLAA"
    expect(formitesti.valid?).to be(false)
  end

  it "is saved to database if valid" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    expect(formitesti).to be_valid
  end

  it "Municipality is invalid" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    formitesti.municipality="gigigigigi"
    expect(formitesti.valid?).to be(false)
  end


  it "Date invalid" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    formitesti.visit_date = '2013-02-31'
    expect(formitesti.valid?).to be(false)
  end

  it "Date not in future" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    formitesti.visit_date = DateTime.now - 10.days
    expect(formitesti).to be_valid
  end

  it "Date in future" do
    formitesti = Visitationform_factory.GetValidVisitationForm
    formitesti.visit_date = DateTime.now + 1.days
    expect(formitesti.valid?).to be(false)
  end
end
FactoryGirl.define do
  factory :image do
    filename "Bird.jpg"
    data nil
    visitation_form :visitation_form
    checksum nil
    category nil
  end

  factory :visitation_form, class: VisitationForm do
    photographer_name "Pekka Murkka"
    visit_date DateTime.new(2013, 6, 29, 10, 15, 30)
    camera "Super Internal Cam"
    lens "Lens Man 2000"
    teleconverter "TC Teleconv"
    municipality "HELSINKI"
    nest "Pedobear's nest for children"
    nest_id 268
    photographer_id 2890
    form_saver_id 2890
  end
end
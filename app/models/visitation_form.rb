class VisitationForm < ActiveRecord::Base
  has_many :images

  validates :nest_id, numericality: { only_integer: true, message: I18n.t('error_value_must_be_number') }
  validates :nest_id, length: { maximum: 5, message: I18n.t('error_value_too_long') }
  validates :municipality, inclusion: { in: TipuApiHelper.GetMunicipalities.map {|v| v['id'] }, message: I18n.t('error_invalid_municipality')}
  validates :photographer_id, presence: true
  validate do |form|
    ringers = TipuApiHelper.GetRingerById(form.photographer_id)
    if !ringers['ringers']['ringer']
      form.errors[:photographer_id] << I18n.t('error_invalid_photographer_id')
    end

    if form.images.count == 0
      form.errors[:images] << I18n.t('error_must_have_one_image')
    end
  end
end

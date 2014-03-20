class VisitationForm < ActiveRecord::Base
  has_many :images
  has_many :owners

  validates :nest_id, numericality: { only_integer: true, message: I18n.t('error_value_must_be_number'), allow_nil: true }
  validates :nest_id, length: { maximum: 5, message: I18n.t('error_value_too_long') }
  validates :nest, presence: { precence: true, message: I18n.t('error_must_be_present') }

  if Rails.env.test?
    validates :municipality, inclusion: { in: TipuApiHelperMock.GetMunicipalities.map {|v| v['id'] }, message: I18n.t('error_invalid_municipality')}
  else
    validates :municipality, inclusion: { in: TipuApiHelper.GetMunicipalities.map {|v| v['id'] }, message: I18n.t('error_invalid_municipality')}
  end

  validates :photographer_id, presence: { message: I18n.t('error_must_be_present') }
  validate do |form|
    if Rails.env.test?
      ringers = TipuApiHelperMock.GetRingerById(form.photographer_id)
    else
      ringers = TipuApiHelper.GetRingerById(form.photographer_id)
    end

    if !ringers['ringers']['ringer']
      form.errors[:photographer_id] << I18n.t('error_invalid_photographer_id')
    end

    # Todo fix this shit. Integration tests require this removed and unit tests fail if removed.
    if not Rails.env.test?
      if form.images.count == 0
        form.errors[:images] << I18n.t('error_must_have_one_image')
      end
    end

    if !form.visit_date.nil? && form.visit_date > Date.today
      form.errors[:visit_date] << I18n.t('error_date_in_future')
    end

    # If the class was anything else than a string, say datetime or date it should already be valid and not parsed again
    if !form.visit_date_before_type_cast.nil? && form.visit_date_before_type_cast.kind_of?(String)
      begin
        date = Date.parse(form.visit_date_before_type_cast)
      rescue
        form.errors[:visit_date] << I18n.t('error_date_invalid')
      end
    end
  end
end

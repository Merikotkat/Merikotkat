class VisitationForm < ActiveRecord::Base
  has_many :images

  validates :nest_id, numericality: { only_integer: true, message: I18n.t('error_value_must_be_number') }
  validates :nest_id, length: { maximum: 5, message: I18n.t('error_value_too_long') }
end

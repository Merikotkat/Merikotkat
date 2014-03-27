class Bird < ActiveRecord::Base
  belongs_to :visitation_form
  has_many :images
end

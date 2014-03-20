class Owner < ActiveRecord::Base
belongs_to :visitation_form

  validates :owner_id, :presence => true
  validates :owner_name, :presence => true


end

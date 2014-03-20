class Owner < ActiveRecord::Base
belongs_to :visitation_form

  validates :owner_id, :presence
  validates :owner_name, :presence


end

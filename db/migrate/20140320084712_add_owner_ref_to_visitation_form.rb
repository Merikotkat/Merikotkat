class AddOwnerRefToVisitationForm < ActiveRecord::Migration
  def change
    add_reference :visitation_forms, :Owner, index: true
  end
end

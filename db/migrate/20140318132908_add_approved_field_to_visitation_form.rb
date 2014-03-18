class AddApprovedFieldToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :approved, :boolean
  end
end

class AddSpeciesIdToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :species_id, :string
  end
end

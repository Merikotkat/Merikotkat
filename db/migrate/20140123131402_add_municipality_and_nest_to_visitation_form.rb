class AddMunicipalityAndNestToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :municipality, :string
    add_column :visitation_forms, :nest, :string
  end
end

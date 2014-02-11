class AddNestIdToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :nest_id, :integer
  end
end

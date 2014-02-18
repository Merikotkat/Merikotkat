class AddBooleanFieldToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :sent, :boolean
  end
end

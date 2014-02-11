class AddFieldsToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :photographer_id, :string
    add_column :visitation_forms, :form_saver_id, :string
  end
end

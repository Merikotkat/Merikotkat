class RemoveUnusedFieldsFromVisitationForm < ActiveRecord::Migration
  def up
    remove_column :visitation_forms, :form_saver_id
  end

  def down
    add_column :visitation_forms, :form_saver_id, :string
  end
end

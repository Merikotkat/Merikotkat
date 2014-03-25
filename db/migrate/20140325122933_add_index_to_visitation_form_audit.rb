class AddIndexToVisitationFormAudit < ActiveRecord::Migration
  def change
    add_index :audit_log_entries, :visitation_form_id
  end
end

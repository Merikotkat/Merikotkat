class AddVisitationFormIdToAuditLogEntries < ActiveRecord::Migration
  def change
    add_column :audit_log_entries, :visitation_form_id, :integer
  end
end

class AddUserIdToPhotos < ActiveRecord::Migration
  def change
    add_index :audit_log_entries, :visitation_form_id
  end
end

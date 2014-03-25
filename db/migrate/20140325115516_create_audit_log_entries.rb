class CreateAuditLogEntries < ActiveRecord::Migration
  def change
    create_table :audit_log_entries do |t|
      t.string :username
      t.string :userid
      t.datetime :timestamp
      t.string :operation
    end
  end
end

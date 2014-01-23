class CreateVisitationForms < ActiveRecord::Migration
  def change
    create_table :visitation_forms do |t|
      t.string :photographer_name
      t.datetime :visit_date

      t.timestamps
    end
  end
end

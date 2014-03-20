class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.integer :visitation_form_id
      t.string :owner_name
      t.string :owner_id

      t.timestamps
    end
  end
end

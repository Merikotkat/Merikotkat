class CreateOwner < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :owner_name
      t.string :owner_id
      t.references :visitation_form
    end
    add_index :owners, :visitation_form_id
  end
end

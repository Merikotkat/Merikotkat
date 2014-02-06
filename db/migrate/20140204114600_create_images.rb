class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :filename
      t.binary :data

      t.references :visitation_form

      t.timestamps
    end

    add_index :images, :visitation_form_id
  end
end

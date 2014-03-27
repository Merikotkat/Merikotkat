class CreateBirds < ActiveRecord::Migration
  def change
    create_table :birds do |t|
      t.string :gender
      t.integer :shyness
      t.string :left_ring_code
      t.string :left_ring_color
      t.string :right_ring_code
      t.string :right_ring_color

      t.integer :visitation_form_id

      t.timestamps
    end

    add_index :birds, :visitation_form_id
  end
end

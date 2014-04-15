class RemoveUnusedFieldsFromImage < ActiveRecord::Migration
  def up
    remove_column :images, :ringed
    remove_column :images, :gender
    remove_column :images, :shyness
    remove_column :images, :left_ring_code
    remove_column :images, :left_ring_color
    remove_column :images, :right_ring_code
    remove_column :images, :right_ring_color
    remove_column :images, :temp_index
  end

  def down
    add_column :images, :ringed, :boolean
    add_column :images, :gender, :string
    add_column :images, :shyness, :integer
    add_column :images, :left_ring_code, :string
    add_column :images, :left_ring_color, :string
    add_column :images, :right_ring_code, :string
    add_column :images, :right_ring_color, :string
    add_column :images, :temp_index, :integer
  end
end

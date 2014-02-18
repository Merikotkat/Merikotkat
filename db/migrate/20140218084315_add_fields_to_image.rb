class AddFieldsToImage < ActiveRecord::Migration
  def change
    add_column :images, :checksum, :string
    add_column :images, :category_id, :integer
  end
end

class AddUploadIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :upload_id, :string
  end
end

class AddThumbnaildataToImages < ActiveRecord::Migration
  def change
    add_column :images, :thumbnaildata, :binary
  end
end

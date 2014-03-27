class AddBirdIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :bird_id, :integer

    add_index :images, :bird_id
  end
end

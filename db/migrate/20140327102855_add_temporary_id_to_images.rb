class AddTemporaryIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :temp_index, :integer
  end
end

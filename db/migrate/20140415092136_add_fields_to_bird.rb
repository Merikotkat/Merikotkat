class AddFieldsToBird < ActiveRecord::Migration
  def change
    add_column :birds, :gender_determination_method, :string
    add_column :birds, :ringed, :integer
  end
end

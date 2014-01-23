class AddCameraSpecificsToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :camera, :string
    add_column :visitation_forms, :lens, :string
    add_column :visitation_forms, :teleconverter, :string
  end
end

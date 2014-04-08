class AddAdditionalInfoToVisitationForm < ActiveRecord::Migration
  def change
    add_column :visitation_forms, :additional_info, :string
  end
end

class AddUpdateByToDonors < ActiveRecord::Migration[6.0]
  def change
    add_column :donors, :updated_by, :integer
  end
end

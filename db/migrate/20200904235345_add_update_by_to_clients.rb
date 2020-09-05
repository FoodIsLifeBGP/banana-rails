class AddUpdateByToClients < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :updated_by, :integer
  end
end

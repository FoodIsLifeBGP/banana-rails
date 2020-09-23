class ChangeZipCodeColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :donors, :address_zip, :string
    change_column :clients, :address_zip, :string
  end
end

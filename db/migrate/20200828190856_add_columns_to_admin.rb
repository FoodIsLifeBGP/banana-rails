class AddColumnsToAdmin < ActiveRecord::Migration[6.0]
  def change
     add_column :admins, :first_name, :string
     add_column :admins, :last_name, :string
     add_column :admins, :user_type, :string
     add_column :admins, :user_status, :string
  end
end

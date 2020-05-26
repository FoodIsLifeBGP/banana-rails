class CreatePasswordResets < ActiveRecord::Migration[6.0]
  def change
    create_table :password_resets do |t|
      t.string :reset_token
      t.datetime :reset_sent_at
      t.string :ip
      t.references :resettable, polymorphic: true
      t.timestamps
    end
  end
end

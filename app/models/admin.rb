class Admin < ApplicationRecord
	has_secure_password	

    validates :email, presence: true
	validates :first_name, presence: true
	validates :last_name, presence: true
    #validates :password, format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,40}\z/}
end

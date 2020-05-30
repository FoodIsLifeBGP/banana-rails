class Client < ApplicationRecord
	has_secure_password

	has_many :claims

	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :address_street, presence: true
	validates :address_city, presence: true
	validates :address_state, presence: true
	validates :address_zip, presence: true
	
	validates :account_status, presence: true
	validates :ethnicity, presence: false
	validates :gender, presence: false
end

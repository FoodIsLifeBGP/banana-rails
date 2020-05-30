class Donor < ApplicationRecord
	has_secure_password

	has_many :donations
	has_many :claims, through: :donations
	accepts_nested_attributes_for :claims

	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :address_street, presence: true
	validates :address_city, presence: true
	validates :address_state, presence: true
	validates :address_zip, presence: true

	validates :account_status, presence: true
	validates :organization_name, presence: true
	validates :business_license, presence: true, length: { is: 9 }
	#TODO: add operation hours ??

	geocoded_by :address
	after_validation :geocode
	def address
		[address_street, address_city, address_state, "US"].compact.join(', ')
	end
end

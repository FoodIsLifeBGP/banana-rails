class Admin < ApplicationRecord
	has_secure_password
    
    
    
    validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :email, presence: true
    validates :password, format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,40}\z/}
    validates_presence_of :first_name, :last_name
end

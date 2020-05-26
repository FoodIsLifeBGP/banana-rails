require 'securerandom'

class PasswordReset < ApplicationRecord
  belongs_to :resettable, polymorphic: true

  def send_password_reset(user)
		generate_token(:reset_token)
		self.reset_sent_at = Time.now
		save!
		UserMailer.with(password_reset: self).forgot_password.deliver_now
	end 

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64(6)
		end while PasswordReset.exists?(column => self[column]) #repeat loop if there is already a donor/client in the system with this same token
  end
  
  def is_valid?
    Time.now - 1.hour <= self.reset_sent_at
  end 

end

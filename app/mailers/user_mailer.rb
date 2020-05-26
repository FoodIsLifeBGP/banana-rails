class UserMailer < ApplicationMailer
 
  def forgot_password
    @password_reset = params[:password_reset]
    @user = @password_reset.resettable
    @greeting = 'Hi'

    mail(to: @user.email, subject: 'Reset Banana App Password Instructions')
  end 

  def reset_confirmation
    @password_reset = params[:password_reset]
    @user = @password_reset.resettable
    @greeting = 'Hi'

    mail(to: @user.email, subject: 'Your Banana App Password Has Been Changed')
  end 

end

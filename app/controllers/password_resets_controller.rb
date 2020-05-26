class PasswordResetsController < ApplicationController
  skip_before_action :authorized
  before_action :set_user_by_email, only: [:create]
  before_action :set_password_reset_by_token, only: [:edit, :update]

  def create
    if @user
      @password_reset = PasswordReset.create(ip: request.remote_ip, resettable_id: @user.id, resettable_type: @user.class.name)
      @password_reset.send_password_reset(@user) if @password_reset
    end
    render status: 202
  end 

  def edit
    if @password_reset
      if @password_reset.is_valid?
        render status: 200
      else
        render json: { message: 'Token has expired.'}, status: 401
      end
    else
      render json: { message: 'User or token was not found.'}, status: 404
    end
  end 

  def update
    if @password_reset
      @user = @password_reset.resettable 
      if !@password_reset.is_valid?
        render json: { message: 'Your token has expired.'}, status: 401
      elsif @user.update(password: params[:password])
        UserMailer.with(password_reset: @password_reset).reset_confirmation.deliver_now
        render status: 200
      else
        render json: { message: 'Incorrect input.' }, status: 400
      end
    else
      render json: { message: 'The user or token was not found.'}, status: 404
    end
  end 

  private

  def set_user_by_email
    if params[:user] == 'donor'
      @user = Donor.find_by email: params[:email]
    elsif params[:user] == 'client'
      @user = Client.find_by email: params[:email]
    end
  end 

  def set_password_reset_by_token
    @password_reset = PasswordReset.find_by reset_token: params[:token]
  end

end

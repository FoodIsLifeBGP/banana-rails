class AdminAuthController < ApplicationController
	skip_before_action :authorized, only: [:create]

	def create
		@admin = Admin.find_by(email: admin_login_params[:email])
		#User#authenticate comes from BCrypt
		if @admin && @admin.authenticate(admin_login_params[:password])
			# encode token comes from ApplicationController
			session[:admin_id] = @admin.id
			token = encode_token({ admin_id: @admin.id })
			render json: { admin: AdminSerializer.new(@admin), jwt: token }, status: :accepted
		else
			render json: { message: 'Invalid email or password' }, status: :unauthorized
		end
	end

	private

	def admin_login_params
		params.require(:admin).permit(:email, :password)
	end
end

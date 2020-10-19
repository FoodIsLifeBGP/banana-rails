class AdminAuthController < ApplicationController
	skip_before_action :authorized, only: [:create]

	def create
		@admin = Admin.find_by(email: admin_login_params[:email])
        password = admin_login_params[:password]
		#User#authenticate comes from BCrypt
        if password.nil? || password.empty?
            return render json: { error: 'password is empty' }, status: :bad_request
        end
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

class AdminsController < ApplicationController
    skip_before_action :authorized, only: [:create]

	def create
		return render json: { error: 'admin email already in use'}, status: :conflict if Admin.exists?({email: admin_params[:email]})
		@admin = Admin.create(admin_params)
		if @admin.valid?
			@token = encode_token(admin_id: @admin.id)
			session[:admin_id] = @admin.id
			render json: { donor: AdminSerializer.new(@admin), jwt: @token }, status: :created
		else
			not_created_user = {email: @admin.email, first_name: @admin.first_name}
			StatusMailer.with(user: not_created_user).account_incomplete(not_created_user).deliver_later
			render json: { error: 'failed to create admin', errors: @admin.errors.full_messages }, status: :bad_request
		end
	end

	def update
		@admin = Admin.find_by_id(params[:id])
        if @admin.nil?
           failure_message = { error: "ID: #{params[:id]} not found" }
           return render  json: failure_message, status: :not_found
        end
		if @admin.update(admin_params)
			render json: @admin
		else
			failure_message = {}
            failure_message['message'] = "Admin id: #{params[:id]} was not updated."
            failure_message['field_errors'] = []
            @admin.errors.each do |attr_name, attr_value|
                message = {}
                message['field'] = attr_name
                message['message'] = attr_value
                failure_message['field_errors'] << message
            end
            render json: failure_message, status: :bad_request
		end
	end

	private

		def admin_params
			params.require(:admin).permit(
					:id,
					:email,
					:password,
					:first_name,
					:last_name,
					:user_type,
					:user_status
			)
		end
end

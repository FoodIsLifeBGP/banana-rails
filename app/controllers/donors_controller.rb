require 'account_status_helper'
class DonorsController < ApplicationController
    skip_before_action :authorized, only: [:create]

	def get_donations
		id = params[:id].to_i
		authorized_id = decoded_token[0]['donor_id']
		if id != authorized_id
			render json: { error: 'Unauthorized' }, status: :forbidden
			return
		end
		@donor = Donor.find(id)
		render json: expire_donations(@donor.donations), include: 'claims', status: :ok
	end

	def get_active_donations
		id = params[:id].to_i
		authorized_id = decoded_token[0]['donor_id']
		if id != authorized_id
			render json: { error: 'Unauthorized' }, status: :forbidden
			return
		end
		active_donations_in_db = Donation.where status: [DonationStatus::ACTIVE, DonationStatus::CLAIMED], donor_id: authorized_id

		render json: expire_donations(active_donations_in_db), include: 'claims', status: :ok
	end

	def create
		return render json: { error: 'donor email already in use'}, status: :conflict if Donor.exists?({email: donor_params[:email]})
		@donor = Donor.create(donor_params)
		if @donor.valid?
			@token = encode_token(donor_id: @donor.id)
			session[:donor_id] = @donor.id

			if @donor.save
				# Tell the StatusMailer to send a welcome email after save
				StatusMailer.with(user: @donor).received_application(@donor).deliver_later
			end
			render json: { donor: DonorSerializer.new(@donor), jwt: @token }, status: :created
		else
			not_created_user = {email: @donor.email, first_name: @donor.first_name}
			StatusMailer.with(user: not_created_user).account_incomplete(not_created_user).deliver_later
			render json: { error: 'failed to create client', errors: @donor.errors.full_messages }, status: :bad_request
		end
	end

	def account_status_update
		id = params[:id].to_i
		status = params[:status]

		@donor = Donor.find_by_id(id)
		if @donor.nil?
			 failure_message = { error: "ID: #{params[:id]} not found" }
			 return render  json: failure_message, status: :not_found
		end
		response = AccountStatusHelper.account_status("Donor", @donor, status, id)
		case status
			when "suspended"
				StatusMailer.with(user: @donor).account_suspended(@donor).deliver_later
			when "approved"
				StatusMailer.with(user: @donor).donor_approved(@donor).deliver_later
		end
		render json: { message: response[:message] }, status: response[:status]
	end

	def update
		@donor = Donor.find_by_id(params[:id])
        if @donor.nil?
           failure_message = { error: "ID: #{params[:id]} not found" }
           return render  json: failure_message, status: :not_found
        end
		if @donor.update(donor_params)
			render json: @donor
		else
			failure_message = {}
            failure_message['message'] = "Donor id: #{params[:id]} was not updated."
            failure_message['field_errors'] = []
            @donor.errors.each do |attr_name, attr_value|
                message = {}
                message['field'] = attr_name
                message['message'] = attr_value
                failure_message['field_errors'] << message
            end
            render json: failure_message, status: :bad_request
		end
	end

	def scan_qr_code
		qr_object = JSON.parse(Base64.decode64(params[:qr_code]))
		claim = Claim.where(client: qr_object['client_id'], donation_id: qr_object['donation_id'], status: ClaimStatus::ACTIVE).first
		if claim
			claim.status = ClaimStatus::CLOSED
			donation = Donation.find(claim.donation_id)
			donation.status = DonationStatus::CLOSED
			claim.save
			donation.save
			render json: { message: 'claim completed' }, status: :accepted
		else
			render json: { error: 'claim not found'}, status: :unprocessable_entity
		end
	end

	private

		def donor_params
			params.require(:donor).permit(
					:id,
					:email,
					:password,
					:first_name,
					:last_name,
					:organization_name,
					:address_street,
					:address_city,
					:address_state,
					:address_zip,
					:pickup_instructions
			)
		end
end


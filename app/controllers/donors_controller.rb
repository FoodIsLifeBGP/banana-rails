class DonorsController < ApplicationController
	skip_before_action :authorized, only: [:create, :account_status]

	def get_donations
		id = params[:id].to_i
		authorized_id = decoded_token[0]['donor_id']
		if id != authorized_id
			render json: { error: 'Unauthorized' }, status: :forbidden
			return
		end
		@donor = Donor.find(id)

		render json: @donor.donations, include: 'claims', status: :ok
	end

	def create
		@donor = Donor.create!(donor_params)
		if @donor.valid?
			@token = encode_token(donor_id: @donor.id)
			session[:donor_id] = @donor.id
			render json: { donor: DonorSerializer.new(@donor), jwt: @token }, status: :created
		else
			render json: { error: 'failed to create donor' }, status: :unprocessable_entity
		end
	end

  # rubocop:todo Metrics/MethodLength, Metrics/AbcSize
  def account_status
    id = params[:id].to_i
    status = params[:status]

    @donor = Donor.find(id)

    case status
    when 'approved'
      success = @donor.update({ account_status: 'approved' })
    when 'pending'
      success = @donor.update({ account_status: 'pending' })
    when 'active'
      success = @donor.update({ account_status: 'active' })
    when 'suspended'
      success = @donor.update({ account_status: 'suspended' })
    end

    if success
      render json: {
        message: "Donor id: #{id} status changed to #{status}. Was: #{@donor.account_status}"
      }, status: :updated
    else
      render json: {
        error: "Donor id: #{id} status not changed to #{status}.  Remained: #{@donor.account_status}"
      }, status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def update
    @donor = Donor.find(params[:id])
    if @donor.update(donor_params)
      render json: @donor
    else
      failure_message = { error: "Donor id: #{params[:id]} not updated. #{@donor.errors.full_messages}" }
      logger.debug('ERROR: On donor#update in donors_controller.rb, line: 59')
      render json: failure_message
    end
  end

  def scan_qr_code
    claim = JSON.parse(Base64.decode64(params[:qr_code]))
    @claim = Claim.find_by(client_id: claim.client_id, donation_id: claim.donation_id)
    return render json: { error: 'claim not found' }, status: :unprocessable_entity unless @claim

    if !@claim.completed
      @claim.completed = true
      @claim.save
      render json: { message: 'claim completed' }, status: :accepted
      nil
    else
      render json: { error: 'claim has already been completed' }, status: :unprocessable_entity
    end
  end

	private

	def donor_params
		params.require(:donor).permit(
			:id,
			:account_status,
			:address_street,
			:address_city,
			:address_state,
			:address_zip,
			:business_license,
			:email,
			:organization_name,
			:password,
			:pickup_location,
		)
	end
end

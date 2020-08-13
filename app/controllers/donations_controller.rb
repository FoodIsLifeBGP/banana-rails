require 'base64'

class DonationsController < ApplicationController
	before_action :authorized
	SEARCH_RADIUS_MILES = 20

	def index
		render json: Donation.all
	end

    def donations_history
     	id = params[:donor_id].to_i
	authorized_id = decoded_token[0]['donor_id']
	if authorized_id != id
		return render json: { error: 'unauthorized'}, status: :unauthorized
	end
        closed_donations_in_db = Donation.where(:status => [DonationStatus::CLOSED, DonationStatus::EXPIRED], donor_id: id).order("updated_at DESC").limit(50)
        render json: closed_donations_in_db
    end

    def claims_history
        id = params[:client_id].to_i
	authorized_id = decoded_token[0]['client_id']
	if authorized_id != id
		return render json: { error: 'unauthorized'}, status: :unauthorized
	end
        closed_claims_in_db = Claim.where(:status =>  [ClaimStatus::CLOSED], client_id: id).order("updated_at DESC").limit(50)
        render json: closed_claims_in_db
    end

	def active
		@active_donations_in_db = Donation.where status: DonationStatus::ACTIVE
		non_expired_donations = expire_donations(@active_donations_in_db)
		if params[:client_lat] && params[:client_long]
			client_coords = [params[:client_lat].to_f, params[:client_long].to_f]
			nearby_donor_ids = Donor.near(client_coords, SEARCH_RADIUS_MILES).map(&:id)
			nearby_available_donations = non_expired_donations.select { |d| nearby_donor_ids.include?(d.donor_id) }
			nearby_available_donations.each {|d| d.distance = d.donor.distance_to(client_coords)}
			return render json: nearby_available_donations
		end
		render json: non_expired_donations
	end

	def show
		render json: Donation.find(params[:id])
	end

	def create
		@donation = Donation.create(donation_params)
		if @donation.valid?
			render json: { donation: DonationSerializer.new(@donation) }, status: :created
		else
			render json: { error: 'failed to create donation', errors: @donation.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		id = params[:id].to_i
		@donation = Donation.find(id)
		authorized_id = decoded_token[0]['donor_id']
		if authorized_id != @donation.donor_id
			return render json: { error: 'unauthorized'}, status: :unauthorized
		end
		if @donation.update(donation_params)
			render json: { donation: DonationSerializer.new(@donation) }, status: :accepted
		else
			render json: { error: 'failed to update donation' }, status: :unprocessable_entity
		end
	end

	def make_claim
		donation_id = params[:id]
		client_id = params[:client_id]

		# No multiple claims by one client on one donation
		if Claim.find_by(donation_id: donation_id, client_id: client_id)
			render json: { error: 'claim already exists for this client and donation' }, status: :unprocessable_entity
			return
		end

		qr_code = Base64.encode64({ 'client_id': params[:client_id], 'donation_id': params[:id] }.to_json).chomp
		claim_params = {
			client_id: params[:client_id],
			donation_id: params[:id],
			qr_code: qr_code,
			status: ClaimStatus::ACTIVE,
		}
		@claim = Claim.new(claim_params)
		claimed_donation = Donation.find(donation_id)
		claimed_donation.status = DonationStatus::CLAIMED
		if @claim.valid?
			Claim.transaction do
				@claim.save
				claimed_donation.save
			end
			render json: { claim: ClaimSerializer.new(@claim) }, status: :accepted
		else
			render json: { error: 'failed to create claim' }, status: :unprocessable_entity
		end
	end

	private

	def donation_params
		params.require(:donation).permit(
			:id,
			:donor_id,
			:category,
			:food_name,
			:pickup_instructions,
			:status,
			:total_amount,
		)
	end
end

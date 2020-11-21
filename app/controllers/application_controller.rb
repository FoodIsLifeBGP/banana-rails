class ApplicationController < ActionController::API
	before_action :authorized, :except => :health

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end

    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
        rescue JWT::DecodeError => exception
          puts exception
          puts exception.backtrace
          raise
        end
      end
    end

    # Find current user (admin, donor, or client) by user id
    def current_user
      if decoded_token
        donor_id = decoded_token[0]['donor_id']
        client_id = decoded_token[0]['client_id']
        admin_id = decoded_token[0]['admin_id']
        @user = nil
        if donor_id
          @user = Donor.find(donor_id)
        elsif client_id
          @user = Client.find(client_id)
        elsif admin_id
          @user = Admin.find(admin_id)
        end
      end
    end

    def logged_in?
      !!current_user
    end

    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

  def health
    render json: { message: 'I am extra healthy' }, status: :ok
  end

  def expire_donations(donations)
    active = Array.new
    donations.each do |donation|
      if donation.created_at < 1.day.ago && (donation.status == DonationStatus::ACTIVE || donation.status == DonationStatus::CLAIMED)
        donation.status = DonationStatus::EXPIRED
        donation.claims.select {|c| c.status == ClaimStatus::ACTIVE}.each do |claim|
          claim.status = ClaimStatus::EXPIRED
        end
        donation.save
      else
        active.push donation
      end
    end
    active
  end
end

require 'account_status_helper'
class AdminsController < ApplicationController
    #skip_before_action :authorized, only: [:get_new_clients]
    
    
    def get_new_clients
        id = params[:id].to_i
        authorized_id = decoded_token[0]['admin_id']
        if authorized_id != id
          return render json: { error: 'unauthorized'}, status: :unauthorized
        end
        clients_count_in_db = Client.where(account_status: AccountStatus::PROCESSING).count
        render json: {newclients: clients_count_in_db}, status: :ok
    end

    def get_new_donors
           id = params[:id].to_i
           authorized_id = decoded_token[0]['admin_id']
           if authorized_id != id
             return render json: { error: 'unauthorized'}, status: :unauthorized
           end
           donors_count_in_db = Donor.where(account_status: AccountStatus::PROCESSING).count
           render json: {newdonors: donors_count_in_db}, status: :ok
       end
    
    def get_donations_status
        id = params[:id].to_i
        authorized_id = decoded_token[0]['admin_id']
        if authorized_id != id
          return render json: { error: 'unauthorized'}, status: :unauthorized
        end
        total_claimed_donations= Donation.where(:status => DonationStatus::CLAIMED).count
        total_active_donations= Donation.where(:status => DonationStatus::ACTIVE).count + total_claimed_donations
        render json: {claimedtotal: total_claimed_donations, activetotal: total_active_donations},status: :ok
    end

    private

    def admin_params
        params.require(:admin).permit(
            :id,
            :email,
            :password,
            :first_name,
            :last_name
        )
    end
    
end

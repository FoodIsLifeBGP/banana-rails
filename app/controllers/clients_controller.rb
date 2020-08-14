require 'account_status_helper'
require 'HERE'
class ClientsController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def index
    @clients = Client.all
  end

  def show
  end

  def new
  end
  

  def create
    return render json: { error: 'client email already in use'}, status: :conflict if Client.exists?({email: client_params[:email]})
    @client = Client.create(client_params)
    if @client.valid?
      @token = encode_token(client_id: @client.id)
      render json: { client: ClientSerializer.new(@client), jwt: @token }, status: :created
    else
        render json: { error: 'failed to create client', errors: @client.errors.full_messages}, status: :bad_request
    end
  end
  
  def account_status_update
      id = params[:id].to_i
      status = params[:status]

      @client = Client.find_by_id(id)
      if @client.nil?
         return render json: { error: "ID: #{params[:id]} not found" }, status: :not_found
      end
      
      response = AccountStatusHelper.account_status("Client", @client, status, id)
      if status == "approved"
        StatusMailer.with(user: @client).client_approved(@client).deliver_later
      end
      render json: { message: response[:message] }, status: response[:status]
  end

  def update
    @client = Client.find_by_id(params[:id])
    
    if @client.nil?
       failure_message = { error: "ID: #{params[:id]} not found" }
       return render  json: failure_message, status: :not_found
    end
    if @client.update(client_params)
      render json: @client
    else
        failure_message = {}
        failure_message['message'] = "Client id: #{params[:id]} was not updated."
        failure_message['field_errors'] = []
        @client.errors.each do |attr_name, attr_value|
            message = {}
            message['field'] = attr_name
            message['message'] = attr_value
            failure_message['field_errors'] << message
        end
        render json: failure_message, status: :bad_request
        puts failure_message
    end
  end

  def get_travel_times
    if params[:client_lat].nil? || params[:client_long].nil? || params[:donorid].nil?
      return render json: {message: 'Need client location to calculate travel'}, status: :bad_request
    end
    donor = Donor.find(params[:donorid].to_i)
    origin = HEREAPI::PointLocation.new(params[:client_lat].to_f, params[:client_long].to_f)
    dest = HEREAPI::PointLocation.new(donor.latitude, donor.longitude)
    mode_to_time = Hash.new
    [HEREAPI::TravelMode::BIKE, HEREAPI::TravelMode::PEDESTRIAN, HEREAPI::TravelMode::PUBLIC_TRANSPORT]
                      .each { |mode| mode_to_time[mode] = HEREAPI::get_time(origin, dest, mode) }
    mode_to_time.delete_if { |k,v| !v.is_a? Numeric }
    render json: mode_to_time, status: mode_to_time.empty? ? :not_found : :ok
  end


  def get_claims
    active_claims_for_client = Claim.where client_id: params[:id].to_i, status: ClaimStatus::ACTIVE
    donations = active_claims_for_client.map(&:donation)
    still_active = expire_donations(donations)
    if params[:client_lat] && params[:client_long]
      client_coords = [params[:client_lat].to_f, params[:client_long].to_f]
      still_active.each {|d| d.distance = d.donor.distance_to(client_coords)}
    end
    render json: still_active, status: :ok
  end

  private

  def client_params
    params.require(:client).permit(
        :email,
        :password,
        :first_name,
        :last_name
    )
  end
end


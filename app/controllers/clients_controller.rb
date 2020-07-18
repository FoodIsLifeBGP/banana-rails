require 'account_status_helper'
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

    def get_donations
    if !params[:client_lat] || !params[:client_long]
      render json: { error: 'Missing client_lat and/or client_long params' }, status: :unprocessable_entity
      return
    end

    client_lat = params[:client_lat].to_f
    client_long = params[:client_long].to_f

    # TODO - transportation_method column was removed from Client table
    # mode = Client.find(params[:id].to_i).transportation_method 

    @distance = 100.0
    # case mode
    # when 'walk'
    #   @distance = 1.0
    # when 'bike'
    #   @distance = 5.0
    # when 'public'
    #   @distance = 5.0
    # when 'car'
    #   @distance = 20.0
    # end

    puts 'travel distance:', @distance

    @available = Donation.all.select do |d|
      # Check if each donation is still active based on the time it was created and its duration.
      # Time.now comes back in seconds, so we divide by 60 to compare in minutes.

      # NOTE: For testing purposes, we are returning all donations, so we don't have to keep creating new ones.
      # NOTE: Uncomment the next line when that is ready to change.
      # (Time.now - d.created_at) / 60 < d.duration_minutes

      # NOTE: Kill next line when making the above change.
      true
    end

    # Uncomment the below code to limit donations by distance.
    # @reachable = @available.select do |donation|
    #   # Check @distance from client to donor of donation
    #   donor = Donor.find(donation.donor_id)
    #   donor.distance_to([client_lat, client_long]) <= @distance
    # end

    # HACK: shows all donations while we are in test mode.  Remove this when uncommenting the above code.
    @reachable = @available

    puts 'reachable:', @reachable.map(&:food_name)
    render json: @reachable, include: 'claims', status: :ok
  end

  def get_claims
    @user = Client.find(params[:id])
    @claims = @user.claims
    @claims_to_return = @claims.as_json
    @claims.each_with_index { |claim, i|
      @claims_to_return[i]['address'] = claim.donation.donor.address
      @claims_to_return[i]['donor'] = claim.donation.donor.organization_name
      @claims_to_return[i]['donation'] = claim.donation.as_json
    }
    render json: @claims_to_return, status: :ok
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


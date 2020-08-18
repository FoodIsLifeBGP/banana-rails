require 'test_helper'


class ClientsControllerTest < ActionDispatch::IntegrationTest

  test "we return 409 status code in the event the client email is already present in the db" do
    post clients_create_url, params: {client: {email: "client@client.com", password: "does not matter",
                                               address_zip: 90210}}
    assert_response :conflict
  end

  test "we successfully register a new client" do
    post clients_create_url, params: {client: {email: "notindb@notindb.com", password: "password1!",
                                               address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :success
    just_added = Client.find_by_email("notindb@notindb.com")
    assert_not_nil just_added
  end

  test "we successfully register a new client and account status defaults to processing" do
    post clients_create_url, params: {client: {email: "acc_status_notindb@notindb.com", password: "password1!",
                                               address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :success
    just_added = Client.find_by_email("acc_status_notindb@notindb.com")
    assert_equal AccountStatus::PROCESSING, just_added.account_status, "account_status should have defaulted to #{AccountStatus::PROCESSING}"
  end

  test "data that fails client registration returns an error response and doesn't write to db" do
    post clients_create_url, params: {client: {email: "acc_status_notindb@notindb.com", password: "password",
                                               address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :bad_request
    res_obj = JSON.parse @response.body
    assert_equal 'Password is invalid', res_obj['errors'][0], 'should have returned invalid password'

  end

  test "we can update account_status for a client" do
    patch '/clients/1/updateStatus', params: {status: AccountStatus::SUSPENDED}, headers: auth_header({client_id: 1})
    assert_response :success
  end

  test "notify caller when client already has requested status" do
    patch '/clients/1/updateStatus', params: {status: AccountStatus::ACTIVE}, headers: auth_header({client_id: 1})
    assert_response 204
  end

  test "notify caller when requested status is invalid" do
    patch '/clients/1/updateStatus', params: {status: 'invalid!!'}, headers: auth_header({client_id: 1})
    assert_response :bad_request
  end

  test "get claims for client" do
    get '/clients/1/get_claims', headers: auth_header({client_id: 1})
    assert_response :success
    claims = JSON.parse @response.body
    assert_equal 1, claims.size, 'should only be one active/pending claim'
  end

  test "get travel times to donation for client" do
    coords = Geocoder.coordinates("800 8th Ave Seattle, WA")
    get "/clients/1/travel_times?client_lat=#{coords[0]}&client_long=#{coords[1]}", headers: auth_header({client_id: 1})
    #eventually we'll want to figure out how to pass this secret to tests
    if ENV["HERE_API_KEY"]
      assert_response :success
    else
      assert_response :not_found
    end
  end

  test "claims history returns list of closed claims" do
    get '/clients/1/claims_history', headers: auth_header({client_id: 1})
    assert_response :success
    history = JSON.parse @response.body
    closed_claims = Claim.where(:client_id => 1, status: ClaimStatus::CLOSED)
    assert_equal history.count, closed_claims.count, 'Incorrect number of claims received in the response'
    closed_claims.each_with_index do |claim, i|
      assert_equal claim.status, history[i]['claim']['status'], "The status of claim: #{history[i]['id']}, is invalid"
  end
end

end

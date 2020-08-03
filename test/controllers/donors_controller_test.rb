require 'test_helper'


class DonorsControllerTest < ActionDispatch::IntegrationTest

  test "we return 409 status code in the event the donor email is already present in the db" do
    post donors_create_url, params: {donor: { email: "donor@donor.com", password: "does not matter",
                                                   address_zip: 90210 }}
    assert_response :conflict
  end

  test "we successfully register a new donor" do
    post donors_create_url, params: {donor: { email: "notindb@notindb.com", password: "password1!", first_name: "New",
                                              address_zip: 98104, account_status: AccountStatus::PROCESSING, last_name: "Donor",
                                              organization_name: "Uwajimaya", address_street: "600 5th Ave S",
                                              pickup_instructions: "On the back steps",
                                              address_city: "Seattle", address_state: "WA", business_license: "ADASDFG"}}
    assert_response :success
    just_added = Donor.find_by_email("notindb@notindb.com")
    assert_not_nil just_added
  end

  test "we register a new donor and account_status defaults to processing" do
    post donors_create_url, params: {donor: { email: "acc_status_test@notindb.com", password: "password1!", first_name: "New",
                                              address_zip: 98104, last_name: "Donor",
                                              organization_name: "Uwajimaya", address_street: "600 5th Ave S",
                                              pickup_instructions: "On the back steps",
                                              address_city: "Seattle", address_state: "WA", business_license: "ADASDFG"}}
    assert_response :success
    just_added = Donor.find_by_email("acc_status_test@notindb.com")
    assert_equal AccountStatus::PROCESSING, just_added.account_status, "account_status should default to #{AccountStatus::PROCESSING} if not specified"
  end

  test "data that fails donor registration returns an error response" do
    post donors_create_url, params: {donor: { email: "acc_status_notindb@notindb.com", password: "password", organization_name: "The Org",
                                                address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :bad_request
    res_obj = JSON.parse @response.body
    assert_equal 'Password is invalid', res_obj['errors'][0], 'should have returned invalid password'

  end

  test "we can update account_status for a donor" do
    patch '/donors/1/updateStatus', params: {status: AccountStatus::SUSPENDED}, headers: auth_header({donor_id: 1})
    assert_response :success
  end

  test "notify caller when donor already has requested status" do
    patch '/donors/1/updateStatus', params: {status: AccountStatus::ACTIVE}, headers: auth_header({donor_id: 1})
    assert_response 204
  end

  test "notify caller when requested donor status is invalid" do
    patch '/donors/1/updateStatus', params: {status: 'invalid!!'}, headers: auth_header({donor_id: 1})
    assert_response :bad_request
  end

  test "get donations for donor" do
    donations_for_donor = Donation.where donor_id: 1
    assert_equal 4, donations_for_donor.size, 'should have 4 donations belonging to donor_id = 1'
    get '/donors/1/get_donations', headers: auth_header({donor_id: 1})
    assert_response :success
    donations_api = JSON.parse @response.body
    assert_equal 3, donations_api.size, 'should return 3 donations, with one expiring'
  end

  test "get active donations for donor" do
    get '/donors/1/get_active_donations', headers: auth_header({donor_id: 1})
    assert_response :success
    active_donations_api = JSON.parse @response.body
    assert_equal 2, active_donations_api.size, 'should return one active and one claimed donation'
    statuses = active_donations_api.map{|d| d['status']}
    assert statuses.include?(DonationStatus::ACTIVE)
    assert statuses.include?(DonationStatus::CLAIMED)
  end

  test "get active donations includes claim info" do
    get '/donors/1/get_active_donations', headers: auth_header({donor_id: 1})
    active_donations_api = JSON.parse @response.body
    claimedDonation = active_donations_api.select { |d| d['status'] == DonationStatus::CLAIMED }.first
    assert_not_nil claimedDonation['claim']['client_name']
    qr_code = claimedDonation['claim']['qr_code']
    assert_not_nil qr_code
    claim_info = JSON.parse(Base64.decode64(qr_code))
    assert_equal 4, claim_info['donation_id'], 'donation id should be 4'
  end

  test "scan qr code should mark claim and donation as closed, return 202" do
    claim = Claim.where(client_id: 1, donation_id: 4).first
    assert_equal ClaimStatus::ACTIVE, claim.status, 'claim should start open'
    post '/donors/scan', params: {qr_code: Base64.encode64({ 'client_id': 1, 'donation_id': 4 }.to_json.chomp)}, headers: auth_header({donor_id: 1})
    assert_response :success
    claim = Claim.where(client_id: 1, donation_id: 4).first
    assert_equal ClaimStatus::CLOSED, claim.status, 'claim should have been closed'
    donation = Donation.find(4)
    assert_equal DonationStatus::CLOSED, donation.status, 'donation should be closed'
  end


end

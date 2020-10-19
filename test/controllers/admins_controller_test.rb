require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "we return 401 status code in the event the admin email is invalid in the db" do
    post '/admins/admin_auth', params: {admin: {email: "admin@admin.com", password: "admin1@123"}}
    assert_response :unauthorized
  end

  test "we return 400 status code if the password is blank" do
      post '/admins/admin_auth', params: {admin: {email: "admin1@admin.com", password: ""}}
    assert_response :bad_request
  end

  test "we return 202 status code in the event the admin email is  in the db" do
    post '/admins/admin_auth', params: {admin: {email: "admin1@admin.com", password: "admin1@123"}}
    assert_response :success
  end

  test "new clients returns list of clients whose account_status is still processing" do
    get '/admins/2/get_new_clients', headers: auth_header({admin_id: 2})
    assert_response :success
    clientsCount = JSON.parse @response.body
    count_in_db = Client.where(account_status: AccountStatus::PROCESSING)
    assert_equal clientsCount['newclients'], count_in_db.count
  end

test "new donors returns list of donors whose account_status is still processing" do
  get '/admins/2/get_new_donors', headers: auth_header({admin_id: 2})
  assert_response :success
  donorsCount = JSON.parse @response.body
  count_in_db = Donor.where(account_status: AccountStatus::PROCESSING)
  assert_equal donorsCount['newdonors'], count_in_db.count
  end

end


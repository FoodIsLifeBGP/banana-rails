require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "we return 401 status code in the event the admin email is invalid in the db" do
    post '/admins/admin_auth', params: {admin: {email: "admin@admin.com", password: "admin1@123"}}
    assert_response :unauthorized
  end

test "we return 400 status code in the event the admin email is invalid in the db" do
   post '/admins/admin_auth', params: {email: "admin@admin.com", password: "admin1@123"}
   assert_response :bad_request
 end

test "we return 401 status code in the event the admin email is invalid in the db" do
  post '/admins/admin_auth', params: {admin: {email: "", password: "admin1@123"}}
  assert_response :bad_request
end

test "we return 401 status code in the event the admin email is invalid in the db" do
  post '/admins/admin_auth', params: {admin: {email: "admin@admin.com", password: ""}}
  assert_response :bad_request
end

  test "we return 200 status code in the event the admin email is invalid in the db" do
    post '/admins/admin_auth', params: {admin: {email: "admin@admin.com", password: ""}}
    assert_response :accepted
  end

end

require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest

  test "we return 409 status code in the event the admin email is already present in the db" do
    post admins_create_url, params: {admin: { email: "admin1@admin.com", password: "does not matter"}}
    assert_response :conflict
  end

  test "we successfully register a new admin" do
    post admins_create_url, params: {admin: { email: "newadmin@admin.com",
                                              password: "password1!",
                                              first_name: "New",
                                              last_name: "Admin",
                                              user_type: "admin",
                                              user_status: AdminStatus::ACTIVE
    }}
    assert_response :success
    just_added = Admin.find_by_email("newadmin@admin.com")
    assert_not_nil just_added
  end

  test "update name of the admin" do
      patch '/admins/1/update', params: {admin: {first_name: "NewAdminName1"}},
          headers: auth_header({admin_id: 1})
      assert_response 200
  end
end

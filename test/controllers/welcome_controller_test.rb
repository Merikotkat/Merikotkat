require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    user = { login_id: 'harald', user_name: 'Harald Hirmuinen', type: 'admin' }
    @visitation_form = visitation_forms(:one)
    @controller.instance_variable_set(:@user, user)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end

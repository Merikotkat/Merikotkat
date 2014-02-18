require 'test_helper'

class VisitationFormsControllerTest < ActionController::TestCase
  setup do
    user = { login_id: 'harald', user_name: 'Harald Hirmuinen',  }
    @visitation_form = visitation_forms(:one)
    @controller.instance_variable_set(:@user, user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visitation_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visitation_form" do
    assert_difference('VisitationForm.count') do
      post :create, visitation_form: { photographer_name: @visitation_form.photographer_name, visit_date: @visitation_form.visit_date }
    end

    assert_redirected_to visitation_form_path(assigns(:visitation_form))
  end

  test "should show visitation_form" do
    get :show, id: @visitation_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visitation_form
    assert_response :success
  end

  test "should update visitation_form" do
    patch :update, id: @visitation_form, visitation_form: { photographer_name: @visitation_form.photographer_name, visit_date: @visitation_form.visit_date }
    assert_redirected_to visitation_form_path(assigns(:visitation_form))
  end

  test "should destroy visitation_form" do
    assert_difference('VisitationForm.count', -1) do
      delete :destroy, id: @visitation_form
    end

    assert_redirected_to visitation_forms_path
  end
end

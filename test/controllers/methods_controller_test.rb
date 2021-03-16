require "test_helper"

class MethodsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get methods_edit_url
    assert_response :success
  end

  test "should get _form" do
    get methods__form_url
    assert_response :success
  end
end

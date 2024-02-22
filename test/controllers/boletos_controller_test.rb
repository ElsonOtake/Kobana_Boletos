require "test_helper"

class BoletosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boletos_index_url
    assert_response :success
  end

  test "should get show" do
    get boletos_show_url
    assert_response :success
  end

  test "should get create" do
    get boletos_create_url
    assert_response :success
  end

  test "should get cancel" do
    get boletos_cancel_url
    assert_response :success
  end
end

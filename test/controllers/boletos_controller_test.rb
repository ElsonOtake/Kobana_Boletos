require "test_helper"

class BoletosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boletos_url
    assert_response :success
  end

  test "should get create" do
    get new_boleto_url
    assert_response :success
  end
end

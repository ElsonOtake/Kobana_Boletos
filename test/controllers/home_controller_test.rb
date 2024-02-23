require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get cities" do
    get home_cities_url
    assert_response :success
  end
end

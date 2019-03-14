require 'test_helper'

class BandsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get bands_create_url
    assert_response :success
  end

  test "should get destroy" do
    get bands_destroy_url
    assert_response :success
  end

end

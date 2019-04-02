require 'test_helper'

class UrlLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get url_links_create_url
    assert_response :success
  end

  test "should get destroy" do
    get url_links_destroy_url
    assert_response :success
  end

end

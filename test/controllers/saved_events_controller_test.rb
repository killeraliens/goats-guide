require 'test_helper'

class SavedEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get saved_events_create_url
    assert_response :success
  end

end

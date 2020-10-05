require 'test_helper'

class ScheduleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schedule_index_url
    assert_response :success
  end

end

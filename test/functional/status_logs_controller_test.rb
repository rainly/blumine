require 'test_helper'

class StatusLogsControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
  end

  test "only logged-in users can create or destroy status log" do
    log_out

    create_status_log
    assert_redirected_to root_path

    destroy_status_log
    assert_redirected_to root_path
  end

  test "should create status log" do
    assert_difference('StatusLog.count') do
      create_status_log
    end 

    assert_response :success
    assert assigns(:status_log)
  end

  test "should destroy status log" do
    assert_difference('StatusLog.count', -1) do
      destroy_status_log
    end

    assert_response :success
    assert assigns(:status_log)
  end

  test "only creator can destroy status log" do
    xhr :delete, :destroy, :id => status_logs(:two).id

    assert_redirected_to root_path
  end

  test "should get teamtalk" do
    xhr :get, :teamtalk

    assert_response :success
    assert_select "#feed_box"
    assert_select "form#new_status_log"
    assert_select "div.row"
  end

  test "should create related issues" do
    issue = issues(:bug_report)
    xhr :post, :create, :status_log => {:content => "foobar #issue-#{issue.id}"}

    assert issue.related_status_logs.member? assigns(:status_log)
  end

  private
    def create_status_log
      xhr :post, :create, :status_log => {:content => "hello"}
    end

    def destroy_status_log
      xhr :delete, :destroy, :id => status_logs(:one).id
    end
end

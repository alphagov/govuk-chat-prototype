require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat = chats(:valid_json)
  end

  test "new" do
    get new_feedback_url(uuid: SecureRandom.uuid), headers: auth_headers
    assert_response :success
    assert_includes @response.body, Feedback.conversation_questions["title"]
  end

  test "create a message feedback" do
    assert_difference("Feedback.count") do
      post feedbacks_url, params: { feedback: { chat_id: @chat.id, version: "message", level: "test", response: { "1234": "Yes" }, uuid: @chat.uuid }, js_enabled: "true" }, headers: auth_headers
    end

    assert_redirected_to new_chat_path(uuid: @chat.uuid)
  end

  test "create a conversation feedback" do
    assert_difference("Feedback.count") do
      post feedbacks_url, params: { feedback: { chat_id: "", uuid: @chat.uuid, version: "test", level: "conversation" }, js_enabled: "false", answers: { "2345": "Yes", "3456": "No" } }, headers: auth_headers
    end

    assert_redirected_to complete_path(uuid: @chat.uuid)
  end

  test "complete" do
    get complete_url, headers: auth_headers
    assert_response :success
    assert_includes @response.body, "Thank you for taking part in our research."
  end

private

  def auth_headers
    encoded_login = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV["USERNAME"], ENV["PASSWORD"]
    )
    { "Authorization" => encoded_login }
  end
end

require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat = chats(:valid_json)
  end

  test "should get new" do
    get new_chat_url, headers: auth_headers
    assert_response :success
    assert_includes @response.body, "I'm GOV.UK Chat"
  end

  test "should create chat with JS enabled" do
    assert_difference("Chat.count") do
      post chats_url, params: { chat: { prompt: "Hello", uuid: SecureRandom.uuid }, js_enabled: "true" }, headers: auth_headers
    end

    assert_redirected_to new_chat_path(uuid: Chat.last.uuid)
  end

  test "should create chat with JS disabled" do
    assert_enqueued_with(job: BackgroundApiCallJob) do
      post chats_url, params: { chat: { prompt: "Hello", uuid: SecureRandom.uuid }, js_enabled: "false" }, headers: auth_headers
    end

    assert_response :success
    assert_includes @response.body, "GOV.UK Chat is still generating"
  end

  test "should redirect to the chat if new message" do
    get refresh_url, params: { uuid: @chat.uuid, count: 0 }, headers: auth_headers
    assert_redirected_to new_chat_path(uuid: Chat.last.uuid)
  end

  test "should render refresh if no more chats created" do
    get refresh_url, params: { uuid: @chat.uuid, count: 1 }, headers: auth_headers
    assert_response :success
    assert_includes @response.body, "GOV.UK Chat is still generating"
  end

private

  def auth_headers
    encoded_login = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV["USERNAME"],
      ENV["PASSWORD"],
    )
    { "Authorization" => encoded_login }
  end
end

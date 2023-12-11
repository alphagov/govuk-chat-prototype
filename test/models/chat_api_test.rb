require "test_helper"
require "minitest/mock"

class ChatApiTest < ActiveSupport::TestCase
  test "it calls the backend api" do
    ChatApi.stub :fetch, "Hello World" do
      assert_equal("Hello World", ChatApi.fetch("12345678-1234-1234-1234-123456789ABC", "Hello World"))
    end
  end
end

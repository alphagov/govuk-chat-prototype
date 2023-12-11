require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test ".for_csv_export scope" do
    assert_equal 1, Chat.for_csv_export.size
  end

  test "#created_at_formatted" do
    assert_equal "01/01/1970 00:00:00", chats(:valid_json).created_at_formatted
  end

  test ".headers" do
    assert_equal %i[id uuid prompt created_at], Chat.headers
  end

  test "#answer is valid JSON" do
    assert_equal "<p>Fine thanks!</p>", chats(:valid_json).answer
  end

  test "#answer is invalid JSON" do
    assert_equal "Fine thanks!", chats(:invalid_json).answer
  end

  test "#answer_formatted is valid JSON" do
    assert_equal "Fine thanks!", chats(:valid_json).answer_formatted
  end

  test "#sources is valid JSON" do
    assert_equal %w[one two three], chats(:valid_json).sources
  end

  test "#sources is invalid JSON" do
    assert_equal [], chats(:invalid_json).sources
  end

  test "#sources_formatter is valid JSON" do
    assert_equal "one | two | three", chats(:valid_json).sources_formatted
  end
end

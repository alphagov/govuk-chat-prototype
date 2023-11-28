require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "#created_at_formatted" do
    assert_equal "01/01/1970 00:00:00", feedbacks(:message).created_at_formatted
  end

  test ".headers" do
    assert_equal [:chat_id, :uuid, :version, :level, :created_at], Feedback.headers
  end
end

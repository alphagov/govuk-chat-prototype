require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  setup do
    @message_questions = {
      "questions" => [
        {
          "id" => "1234",
          "header" => "dummy_0",
          "datatype" => "radio",
          "options" => %w[Yes No],
        },
      ],
    }

    @conversation_questions = {
      "title" => "Test",
      "groups" => [
        {
          "group_name" => "Group A",
          "questions" => [
            {
              "id" => "2345",
              "header" => "dummy_1",
              "datatype" => "radio",
              "options" => %w[Yes No],
            },
          ],
        },
        {
          "group_name" => "Group B",
          "questions" => [
            {
              "id" => "3456",
              "header" => "dummy_2",
              "datatype" => "radio",
              "options" => %w[Yes No],
            },
          ],
        },
      ],
    }
  end

  test ".for_csv_export scope" do
    assert_equal 2, Feedback.for_csv_export.size
  end

  test "#created_at_formatted" do
    assert_equal "01/01/1970 00:00:00", feedbacks(:message).created_at_formatted
  end

  test ".headers" do
    assert_equal %i[chat_id uuid version level created_at], Feedback.headers
  end

  test ".message_questions" do
    assert_equal @message_questions, Feedback.message_questions
  end

  test ".conversation_questions" do
    assert_equal @conversation_questions, Feedback.conversation_questions
  end

  test ".message_headers" do
    assert_equal %w[dummy_0], Feedback.message_headers
  end

  test ".conversation_headers" do
    assert_equal %w[dummy_1 dummy_2], Feedback.conversation_headers
  end

  test "#message_answers" do
    assert_equal %w[Yes], feedbacks(:message).message_answers
  end

  test "#conversation_answers" do
    assert_equal %w[Yes No], feedbacks(:conversation).conversation_answers
  end
end

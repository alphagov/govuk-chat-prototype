class Feedback < ApplicationRecord
  belongs_to :chat, optional: true

  scope :for_csv_export, lambda {
    select(headers, :response).where(
      version: [ENV["CONVERSATION_FEEDBACK_VERSION"], ENV["MESSAGE_FEEDBACK_VERSION"]],
    )
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.headers
    %i[chat_id uuid version level created_at]
  end

  def self.message_questions
    @message_questions ||= load_questions("message")
  end

  def self.conversation_questions
    @conversation_questions ||= load_questions("conversation")
  end

  def self.message_headers
    message_questions["questions"].pluck("header")
  end

  def self.conversation_headers
    conversation_questions["groups"].flat_map { |group| group["questions"].pluck("header") }
  end

  def message_answers
    answers(self.class.message_questions["questions"])
  end

  def conversation_answers
    self.class.conversation_questions["groups"].flat_map { |group| answers(group["questions"]) }
  end

private

  def self.load_questions(level)
    filename = ENV["#{level.upcase}_FEEDBACK_FILENAME"]
    version = ENV["#{level.upcase}_FEEDBACK_VERSION"]

    config = YAML.load_file("feedback/#{filename}.yaml")
    config[version]
  end

  private_class_method :load_questions

  def answers(questions)
    questions.map do |question|
      answer = response[question["id"]]
      answer.is_a?(Hash) ? answer.values.join(" | ") : answer
    end
  end
end

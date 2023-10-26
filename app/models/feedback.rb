class Feedback < ApplicationRecord
  belongs_to :chat, optional: true

  scope :for_csv_export, -> {
    select(self.headers, :response).where(
      version: [ENV["CONVERSATION_FEEDBACK_VERSION"], ENV["MESSAGE_FEEDBACK_VERSION"]]
    )
  }

  def self.headers
    [:id, :chat_id, :uuid, :version, :level, :created_at, :updated_at]
  end

  def self.message_questions
    @@message_questions ||= load_questions("message")
  end

  def message_questions
    self.class.message_questions
  end

  def self.conversation_questions
    @@conversation_questions ||= load_questions("conversation")
  end

  def conversation_questions
    self.class.conversation_questions
  end

  def self.message_headers
    self.message_questions["questions"].pluck("header")
  end

  def self.conversation_headers
    conversation_questions["groups"].flat_map { |group| group["questions"].pluck("header") }
  end

  def message_answers
    answers(message_questions["questions"])
  end

  def conversation_answers
    conversation_questions["groups"].flat_map { |group| answers(group["questions"]) }
  end

private

  def self.load_questions(level)
    config = YAML.load_file("feedback/#{level}.yaml")
    config[ENV["#{level.upcase}_FEEDBACK_VERSION"]]
  end

  def answers(questions)
    questions.map do |question|
      answer = response[question["id"]]
      answer.is_a?(Hash) ? answer.values.join(" | ") : answer
    end
  end
end

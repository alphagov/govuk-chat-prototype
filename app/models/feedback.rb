class Feedback < ApplicationRecord
  belongs_to :chat, optional: true

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

  def self.csv_headers
    sanitize_column_names + message_questions["questions"].pluck("title") + conversation_questions["questions"].pluck("title")
  end

  def self.sanitize_column_names
    cols = column_names.dup
    cols.delete("response")
    cols
  end

  def csv_line
    if level == "conversation"
      length = message_questions["questions"].length
      sanitize_attributes.values + Array.new(length) { nil } + sanitize_response
    else
      length = conversation_questions["questions"].length
      sanitize_attributes.values + sanitize_response + Array.new(length) { nil }
    end
  end

  def sanitize_response
    sanitized_response = JSON.parse(response)
    sanitized_response.each do |k, v|
      sanitized_response[k] = v.values.join(" | ") if v.is_a?(Hash)
    end
    sanitized_response.values
  end

  def sanitize_attributes
    attributes.except("response")
  end

  private

  def self.load_questions(level)
    config = YAML.load_file("feedback/#{level}.yaml")
    config[ENV["#{level.upcase}_FEEDBACK_VERSION"]]
  end
end

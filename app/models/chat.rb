class Chat < ApplicationRecord
  has_many :feedbacks

  scope :for_csv_export, -> {
    select(self.headers).where(uuid: Feedback.for_csv_export.map(&:uuid))
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.headers
    [:id, :uuid, :prompt, :reply, :created_at]
  end

  def answer
    begin
      JSON.parse(reply)["answer"]
    rescue JSON::ParserError
      reply
    end
  end

  def sources
    begin
      JSON.parse(reply)["sources"]
    rescue JSON::ParserError
      []
    end
  end
end

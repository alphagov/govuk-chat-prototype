class Chat < ApplicationRecord
  has_many :feedbacks

  scope :for_csv_export, -> {
    select(self.headers).where(uuid: Feedback.for_csv_export.map(&:uuid))
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.has_at_least_one_question?(uuid)
    where(uuid: uuid).any?
  end

  def self.headers
    [:id, :uuid, :prompt, :created_at]
  end

  def answer
    begin
      JSON.parse(reply)["answer"]
    rescue JSON::ParserError
      reply
    end
  end

  def answer_formatted
    parser = Nokogiri::HTML(answer, nil, Encoding::UTF_8.to_s)
    parser.xpath('//text()').map(&:text).join(' ').squish
  end

  def sources
    begin
      JSON.parse(reply)["sources"]
    rescue JSON::ParserError
      []
    end
  end

  def sources_formatted
    sources.join(" | ")
  end
end

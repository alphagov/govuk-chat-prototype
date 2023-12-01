class Chat < ApplicationRecord
  has_many :feedbacks

  scope :for_csv_export, lambda {
    select(headers).where(uuid: Feedback.for_csv_export.map(&:uuid))
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.headers
    %i[id uuid prompt created_at]
  end

  def answer
    JSON.parse(reply)["answer"]
  rescue JSON::ParserError
    reply
  end

  def answer_formatted
    parser = Nokogiri::HTML(answer, nil, Encoding::UTF_8.to_s)
    parser.xpath("//text()").map(&:text).join(" ").squish
  end

  def sources
    JSON.parse(reply)["sources"]
  rescue JSON::ParserError
    []
  end

  def sources_formatted
    sources.join(" | ")
  end
end

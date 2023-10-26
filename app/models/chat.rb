class Chat < ApplicationRecord
  has_many :feedbacks

  scope :for_csv_export, -> {
    select(self.headers).where(uuid: Feedback.for_csv_export.map(&:uuid))
  }

  def self.headers
    [:id, :uuid, :prompt, :created_at, :updated_at]
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

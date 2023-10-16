class Chat < ApplicationRecord
  has_many :feedbacks

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

class Chat < ApplicationRecord
  def answer
    JSON.parse(reply)["answer"]
  end

  def sources
    JSON.parse(reply)["sources"]
  end
end

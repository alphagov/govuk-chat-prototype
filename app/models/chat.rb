class Chat < ApplicationRecord
  validate :validate_chat

  def answer
    JSON.parse(reply)["answer"]
  end

  def sources
    JSON.parse(reply)["sources"]
  end

  private

  def validate_chat
    ChatValidator.new(self).validate
  end
end

class PIIValidator
  def initialize(prompt)
    @prompt = prompt
  end

  def contains_no_pii?
    dlp = Google::Cloud::Dlp.dlp_service

    request_configuration
    
    item_to_inspect = { value: @prompt }

    project_id = ENV["GOOGLE_CLOUD_PROJECT"]

    parent = "projects/#{project_id}/locations/global"
    response = dlp.inspect_content(
      parent: parent,
      inspect_config: request_configuration,
      item: item_to_inspect
    )
    
    response.result.findings.empty?
  end

  private

  def request_configuration
    {
      info_types:     [{ name: "PERSON_NAME" }, { name: "US_STATE" }],
      min_likelihood: :LIKELY,
      limits:         { max_findings_per_request: 1 },
      include_quote:  true
    }    
  end
end

class ChatValidator
  def initialize(chat)
    @chat = chat
  end

  def validate
    unless PIIValidator.new(@chat.prompt).contains_no_pii?
      @chat.errors.add(:prompt, "We detected personal information in your query, please remove this and try again")
    end
  end
end

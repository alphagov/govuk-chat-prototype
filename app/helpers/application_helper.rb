require "nokogiri"

module ApplicationHelper
  def apply_govuk_styles(text)
    GovukStyler.new(text).update
  end
end

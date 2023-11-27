require "nokogiri"
require_relative "style_updater"

class GovukStyler
  attr_reader :html, :govuk_style_updaters

  def initialize(text)
    @html = Nokogiri::HTML5.fragment(text)
    @govuk_style_updaters = [
      Anchor.new,
      Paragraph.new,
      Header.new,
      UnorderedList.new,
      OrderedList.new,
    ]
  end

  def update
    styled_html = html
    govuk_style_updaters.each do |styler|
      styled_html = styler.style(styled_html)
    end
    styled_html.to_html.html_safe
  end
end

require "nokogiri"

class StyleUpdater
  def style(html)
    raise RuntimeError, "Abstract method called"
  end
end

class Anchor < StyleUpdater
  def style(html)
    html.css("a").each do |link|
      href = link.attribute_nodes.first.value
      link.attribute_nodes.first.value = "https://www.gov.uk#{href}" if href.start_with?("/")
      link["class"] = "govuk-link"
      link["target"] = "_blank"
    end
    html
  end
end

class Paragraph < StyleUpdater
  def style(html)
    html.css("p").each do |paragraph|
      paragraph["class"] = "govuk-body"
    end
    html
  end
end

class Header < StyleUpdater
  def style(html)
    html.css("h1, h2, h3, h4, h5, h6").each do |header|
      header.name = "p"
      header["class"] = "govuk-body-l govuk-chat-header"
    end
    html
  end
end

class UnorderedList < StyleUpdater
  def style(html)
    html.css("ul").each do |list|
      list["class"] = "govuk-list govuk-list--bullet"
    end
    html
  end
end

class OrderedList < StyleUpdater
  def style(html)
    html.css("ol").each do |list|
      list["class"] = "govuk-list govuk-list--number"
    end
    html
  end
end

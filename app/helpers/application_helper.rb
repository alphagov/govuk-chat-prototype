module ApplicationHelper
  def markdown(text)
    # The options work with plain text. They are being ommited whilst we test rendering...
    # ...the API response, which includes HTML.
    # options = [:hard_wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks]
    Markdown.new(text).to_html.html_safe
  end
end

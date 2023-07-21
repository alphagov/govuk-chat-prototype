class MarkdownTest < Minitest::Test
  include ApplicationHelper

  @@html = <<~HEREDOC
    <p>Lorem ipsum and all that jazz <a href="https://www.example.com">https://www.example.com</a></p>

    <p>Email this dude! <a href="mailto:fred@bedrock.com">fred@bedrock.com</a></p>

    <ul>
    <li>One</li>
    <li>Two</li>
    </ul>
  HEREDOC

  def test_it_does_not_alter_html_when_given_html
    assert_equal @@html, markdown(@@html)
  end

  def test_it_returns_the_correct_html_given_markdown
    md = <<~HEREDOC
      Lorem ipsum and all that jazz [https://www.example.com](https://www.example.com)

      Email this dude! fred@bedrock.com

      - One
      - Two
    HEREDOC

    assert_equal @@html, markdown(md)
  end

  def test_it_converts_hrefs_and_lists_given_plain_text
    text = <<~HEREDOC
      Lorem ipsum and all that jazz https://www.example.com

      Email this dude! fred@bedrock.com

      - One
      - Two
    HEREDOC

    assert_equal @@html, markdown(text)
  end
end

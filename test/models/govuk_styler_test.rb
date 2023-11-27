require "test_helper"

class GovukStylerTest < ActiveSupport::TestCase
  test "#update with empty string" do
    assert_equal("", GovukStyler.new("").update)
  end

  test "#update with nil string" do
    assert_equal("", GovukStyler.new(nil).update)
  end

  test "#update with paragraph" do
    assert_equal(
      '<p class="govuk-body">Hello world</p>',
      GovukStyler.new("<p>Hello world</p>").update)
  end

  test "#update with header 1" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h1>Hello world</h1>").update)
  end

  test "#update with header 2" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h2>Hello world</h2>").update)
  end

  test "#update with header 3" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h3>Hello world</h3>").update)
  end

  test "#update with header 4" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h4>Hello world</h4>").update)
  end

  test "#update with header 5" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h5>Hello world</h5>").update)
  end

  test "#update with header 6" do
    assert_equal(
      '<p class="govuk-body-l govuk-chat-header">Hello world</p>',
      GovukStyler.new("<h6>Hello world</h6>").update)
  end

  test "#update with unordered list" do
    assert_equal(
      '<ul class="govuk-list govuk-list--bullet"><li>Hello</li><li>world</li></ul>',
      GovukStyler.new("<ul><li>Hello</li><li>world</li></ul>").update)
  end

  test "#update with ordered list" do
    assert_equal(
      '<ol class="govuk-list govuk-list--number"><li>Hello</li><li>world</li></ol>',
      GovukStyler.new("<ol><li>Hello</li><li>world</li></ol>").update)
  end

  test "#update with anchor - govuk" do
    assert_equal(
      '<a href="https://www.gov.uk/hello-world" class="govuk-link" target="_blank">Hello world</a>',
      GovukStyler.new('<a href="/hello-world">Hello world</a>').update)
  end

  test "#update with anchor - non-govuk" do
    assert_equal(
      '<a href="https://www.example.com/hello-world" class="govuk-link" target="_blank">Hello world</a>',
      GovukStyler.new('<a href="https://www.example.com/hello-world">Hello world</a>').update)
  end
end

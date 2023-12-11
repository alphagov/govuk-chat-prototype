require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#apply_govuk_styles with empty string" do
    assert_dom_equal("", apply_govuk_styles(""))
  end

  test "#apply_govuk_styles with nil string" do
    assert_dom_equal("", apply_govuk_styles(nil))
  end

  test "#apply_govuk_styles with valid html" do
    assert_dom_equal(
      '<p class="govuk-body">Hello world</p>',
      apply_govuk_styles("<p>Hello world</p>"),
    )
  end
end

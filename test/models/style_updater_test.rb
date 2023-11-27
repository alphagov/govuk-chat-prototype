require "test_helper"

class StyleUpdaterTest < ActiveSupport::TestCase
  test "#style raises exception" do
    error = assert_raises(RuntimeError) do
      StyleUpdater.new.style("")
    end
    assert_equal "Abstract method called", error.message
  end
end

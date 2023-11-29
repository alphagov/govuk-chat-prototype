require "test_helper"

class BackgroundApiCallJobTest < ActiveJob::TestCase
  test "enqueues a new job" do
    assert_enqueued_with(job: BackgroundApiCallJob) do
      BackgroundApiCallJob.perform_later("12345678-1234-1234-1234-123456789ABC", "How are you?", 1)
    end
    assert_equal 2, Chat.count
  end
end

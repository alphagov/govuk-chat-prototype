require 'google/cloud/storage'

class CloudStorage
  def self.read_file(filename)
    storage = Google::Cloud::Storage.new(project: ENV["GCP_UR_PROJECT_NAME"])
    bucket = storage.bucket(ENV["GCP_UR_BUCKET_NAME"], skip_lookup: true)
    file = bucket.file(filename)

    file.download.read
  end
end

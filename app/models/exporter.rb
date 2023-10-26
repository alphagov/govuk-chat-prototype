require "csv"
require "google/cloud/storage"

class Exporter
  def self.export_chat
    csv_data = CSV.generate do |csv|
      csv << Chat.headers + [:answer, :sources]
      Chat.for_csv_export.each do |chat|
        chat_instance = Chat.find(chat.id)
        csv << [
                 chat.id,
                 chat.uuid,
                 chat.prompt,
                 format_timestamp(chat.created_at),
                 format_timestamp(chat.updated_at)
               ] + [
                 chat_instance.answer_formatted,
                 chat_instance.sources_formatted
               ]
      end
    end
    write_file("chat", csv_data)
  end

  def self.export_feedback
    csv_data = CSV.generate do |csv|
      csv << Feedback.headers + [:prompt] + Feedback.message_headers + Feedback.conversation_headers
      Feedback.for_csv_export.each do |feedback|
        prompt = feedback.chat ? feedback.chat.prompt : ""
        question_answers = feedback.message_answers
        question_answers += feedback.conversation_answers
        csv << [
                 feedback.id,
                 feedback.chat_id,
                 feedback.uuid,
                 feedback.version,
                 feedback.level,
                 format_timestamp(feedback.created_at),
                 format_timestamp(feedback.updated_at)
               ] + [prompt] + question_answers
      end
    end
    write_file("feedback", csv_data)
  end

  def self.export
    export_chat
    export_feedback
  end

  private

  def self.format_timestamp(datetime)
    datetime.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.write_file(filename, data)
    filename = "#{filename}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"

    if ENV["EXPORT_TO_CLOUD_STORAGE"] == "true"
      write_to_gcp(filename, data)
    else
      write_locally(filename, data)
    end
  end

  def self.write_to_gcp(filename, data)
    storage = Google::Cloud::Storage.new project: ENV["GCP_PROJECT_NAME"]
    bucket = storage.bucket(ENV["GCP_BUCKET_NAME"])
    bucket.create_file StringIO.new(data), filename
  end

  def self.write_locally(filename, data)
    Dir.mkdir "exports" unless Dir.exist?("exports")
    file = File.open("exports/#{filename}", "w")
    file.puts data
    file.close
  end
end

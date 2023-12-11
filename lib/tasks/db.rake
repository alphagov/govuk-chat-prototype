require "csv"
require "google/cloud/storage"

def write_file(filename, data)
  storage = Google::Cloud::Storage.new project: ENV["GCP_PROJECT_NAME"]
  bucket = storage.bucket(ENV["GCP_BUCKET_NAME"])
  filename = "#{filename}-#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv"
  bucket.create_file StringIO.new(data), filename
end

namespace :db do
  desc "Exports data from Chats as CSV"
  task export_chat: :environment do
    csv_data = CSV.generate do |csv|
      csv << Chat.headers + %i[answer sources]
      Chat.for_csv_export.each do |chat|
        chat_instance = Chat.find(chat.id)
        csv << [
          chat.id,
          chat.uuid,
          chat.prompt,
          chat.created_at_formatted,
        ] + [
          chat_instance.answer_formatted,
          chat_instance.sources_formatted,
        ]
      end
    end
    write_file("chat", csv_data)
  end

  desc "Exports data from Feedback as CSV"
  task export_feedback: :environment do
    csv_data = CSV.generate do |csv|
      csv << Feedback.headers + [:prompt] + Feedback.message_headers + Feedback.conversation_headers
      Feedback.for_csv_export.each do |feedback|
        prompt = feedback.chat ? feedback.chat.prompt : ""
        question_answers = feedback.message_answers
        question_answers += feedback.conversation_answers
        csv << [
          feedback.chat_id,
          feedback.uuid,
          feedback.version,
          feedback.level,
          feedback.created_at_formatted,
        ] + [prompt] + question_answers
      end
    end
    write_file("feedback", csv_data)
  end

  desc "Exports data from Chats and Feedback as CSV"
  task export: :environment do
    Rake::Task["db:export_chat"].execute
    Rake::Task["db:export_feedback"].execute
  end
end

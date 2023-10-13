require "csv"

namespace :db do
  desc "Exports data from Chats as CSV"
  task export_chat: :environment do
    CSV.open("chat.csv", "w") do |csv|
      csv << Chat.headers
      Chat.for_csv_export.each do |chat|
        csv << [chat.id, chat.uuid, chat.prompt, chat.reply, chat.created_at_formatted]
      end
    end
  end

  desc "Exports data from Feedback as CSV"
  task export_feedback: :environment do
    CSV.open("feedback.csv", "w") do |csv|
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
                 feedback.created_at_formatted
              ] + [prompt] + question_answers
      end
    end
  end

  desc "Exports data from Chats and Feedback as CSV"
  task export: :environment do
    Rake::Task["db:export_chat"].execute
    Rake::Task["db:export_feedback"].execute
  end
end

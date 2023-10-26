namespace :db do
  desc "Exports data from Chats as CSV"
  task export_chat: :environment do
    Exporter.export_chat
  end

  desc "Exports data from Feedback as CSV"
  task export_feedback: :environment do
    Exporter.export_feedback
  end

  desc "Exports data from Chats and Feedback as CSV"
  task export: :environment do
    Exporter.export
  end
end

class ExporterJob < ApplicationJob
  queue_as :default

  def perform
    Exporter.export
  end
end

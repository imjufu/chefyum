class UpdateCiqualDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    dirpath = Ciqual::XmlDownloader.new.download
    parser = Ciqual::XmlParser.new(dirpath)
    parser.parse!

    Food.upsert_all(parser.foods.values, returning: false, unique_by: [ :source, :source_code ])
  end
end

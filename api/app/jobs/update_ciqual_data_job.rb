class UpdateCiqualDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    dirpath = Ciqual::XmlDownloader.new.download
    parser = Ciqual::XmlParser.new(dirpath)
    parser.parse!

    FoodGroup.upsert_all(parser.food_groups.values, returning: false, unique_by: :code)
    Food.upsert_all(parser.foods.values, returning: false, unique_by: :code)
  end
end

require "rails_helper"

RSpec.describe UpdateCiqualDataJob, type: :job do
  describe "#perform" do
    before do
      stub_request(:get, "https://www.data.gouv.fr/fr/datasets/r/e31dd87c-8ad0-43e4-bdaa-af84ad243dc6").
        with(
          headers: {
            "Accept"=>"*/*",
            "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host"=>"www.data.gouv.fr",
            "User-Agent"=>"ChefYum/0.0.1"
          }).
        to_return(status: 200, body: File.open(Rails.root.join("spec/fixtures/lite_ciqual_archive.zip"), "r").read, headers: {})
    end

    it "saves ciqual foods in the database" do
      expect do
        UpdateCiqualDataJob.perform_now
      end.to change(Food, :count).from(0).to(3185)
    end

    it "saves ciqual foods code, label, food_group_code and nutrition_facts" do
      expect do
        UpdateCiqualDataJob.perform_now
      end.to change { Food.first&.as_json }.from(nil).to(
        match({
          "id" => an_instance_of(Integer),
          "label" => "Pastis",
          "source" => "ciqual.anses",
          "source_code" => "1000",
          "source_label" => "Pastis",
          "nutrition_facts" => {
            "salt_in_g_per_100g" => 0.0,
            "energy_in_kcal_per_100g" => 274.0,
            "fibers_in_g_per_100g" => 0.0,
            "lipids_in_g_per_100g" => 0.0,
            "sugars_in_g_per_100g" => 0.0,
            "proteins_in_g_per_100g" => 0.0,
            "carbohydrates_in_g_per_100g" => 2.86,
            "saturated_fatty_acids_in_g_per_100g" => 0.0
          },
          "created_at" => an_instance_of(String),
          "updated_at" => an_instance_of(String)
        })
      )
    end
  end
end

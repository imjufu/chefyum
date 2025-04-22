require "rails_helper"

RSpec.describe Ciqual::XmlDownloader do
  let(:subject) { Ciqual::XmlDownloader.new }

  describe "#download" do
    before do
      stub_request(:get, "https://www.data.gouv.fr/fr/datasets/r/e31dd87c-8ad0-43e4-bdaa-af84ad243dc6").
        with(
          headers: {
            "Accept"=>"*/*",
            "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host"=>"www.data.gouv.fr",
            "User-Agent"=>"ChefYum/0.0.1"
          }).
        to_return(status: 200, body: File.open(Rails.root.join("spec/fixtures/ciqual_archive.zip"), "r").read, headers: {})
    end

    it "returns a Pathname" do
      expect(subject.download).to be_a Pathname
    end

    it "returns the dirpath where the ciqual archive has been downloaded" do
      dirpath = subject.download
      expect(Dir.glob(dirpath.join("archive.zip")).length).to eq 1
    end

    it "returns the dirpath where the ciqual files has been extracted" do
      dirpath = subject.download
      expect(Dir.glob(dirpath.join("*.xml")).length).to eq 5
    end
  end
end

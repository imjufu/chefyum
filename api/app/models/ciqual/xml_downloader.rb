require "net/http"
require "zip"

module Ciqual
  class XmlDownloader
    # Download nutritional composition table of Ciqual foods
    # Data from data.gouv.fr:
    # https://www.data.gouv.fr/fr/datasets/table-de-composition-nutritionnelle-des-aliments-ciqual/
    DATASET_URI = "https://www.data.gouv.fr/fr/datasets/r/e31dd87c-8ad0-43e4-bdaa-af84ad243dc6"
    USER_AGENT = "ChefYum/0.0.1"

    def initialize
      @uri = URI(DATASET_URI)
      @tmpdir = Rails.root.join("tmp", "ciqual", SecureRandom.urlsafe_base64)
      @http_response = nil
    end

    def download
      Dir.mkdir(@tmpdir)
      @target = File.open(@tmpdir.join("archive.zip"), "w")
      download_archive
      extract_archive
      @tmpdir
    end

    protected

    def download_archive
      Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new @uri
        request["User-Agent"] = USER_AGENT
        http.request request do |response|
          @http_response = response
          case response.code
          when "302"
            @uri = URI(response["location"])
            return download_archive
          when "200"
            @target.binmode # no newline conversion | no encoding conversion | encoding is ASCII-8BIT
            response.read_body do |chunk|
              chunk = yield chunk if block_given?
              @target.write(chunk)
            end
            return @target.tap(&:close)
          else
            raise Net::HTTPError.new(response.body, nil)
          end
        end
      end
    end

    def extract_archive
      Zip::File.open(@target.path) do |zip_files|
        zip_files.each do |zip_file|
          zip_file.extract(@tmpdir.join(zip_file.name))
        end
      end
    end
  end
end

require "open-uri"
require "zip"

module Ciqual
  class XmlDownloader
    # Download nutritional composition table of Ciqual foods
    # Data from data.gouv.fr:
    # https://www.data.gouv.fr/fr/datasets/table-de-composition-nutritionnelle-des-aliments-ciqual/
    DATASET_URI = "https://www.data.gouv.fr/fr/datasets/r/e31dd87c-8ad0-43e4-bdaa-af84ad243dc6"
    USER_AGENT = "ChefYum/0.0.1"

    def download
      # Make a temporary directory to store the archive and the extracted xml files
      tmp_dir = Rails.root.join("tmp", "ciqual", SecureRandom.urlsafe_base64)
      Dir.mkdir(tmp_dir)

      url = URI(DATASET_URI)
      options = {}

      # It was shown that in a random sample approximately 20% of websites will
      # simply refuse a request which doesn't have a valid User-Agent.
      options["User-Agent"] = USER_AGENT

      # Finally we download the file. Here we mustn't use simple #open that open-uri
      # overrides, because this is vulnerable to shell execution attack (if #open
      # method detects a starting pipe (e.g. "| ls"), it will execute the following
      # as a shell command).
      io = url.open(options)

      # open-uri will return a StringIO instead of a Tempfile if the filesize
      # is less than 10 KB, so we patch this behaviour by converting it into a
      # Tempfile.
      archive_path = tmp_dir.join("archive.zip")
      if io.is_a?(StringIO)
        File.open(archive_path, "w") { |f| f.write(io.read) }
      else # io is a Tempfile
        io.close
        FileUtils.mv(io.path, archive_path)
      end

      Zip::File.open(archive_path) do |zip_files|
        zip_files.each do |zip_file|
          zip_file.extract(tmp_dir.join(zip_file.name))
        end
      end

      tmp_dir
    rescue *[
      SocketError,          # domain not found
      OpenURI::HTTPError,   # response status 4xx or 5xx
      RuntimeError,         # redirection errors (e.g. redirection loop)
      URI::InvalidURIError  # invalid URL
    ] => error
      # open-uri will throw a RuntimeError when it detects a redirection loop, so
      # we want to reraise the exception if it was some other RuntimeError
      raise if error.instance_of?(RuntimeError) && error.message !~ /redirection/
      # We raise our unified Error class
      raise Error, "Download failed (#{url}): #{error.message}"
    end
  end
end

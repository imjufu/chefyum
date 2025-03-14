module RequestSpecHelper
  def json
    return nil if response.body.empty?

    JSON.parse(response.body)
  end
end

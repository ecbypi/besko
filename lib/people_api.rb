require "net/https"

class PeopleApi
  URI = URI.parse "https://m.mit.edu/apis/people/"

  def initialize
    @client = Net::HTTP.new URI.host, URI.port
    @client.use_ssl = true
  end

  def query(query)
    uri = URI.dup
    uri.query = "q=#{CGI.escape(query.to_s)}"

    request = Net::HTTP::Get.new(uri)
    response = @client.request(request)

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      []
    end
  end
end

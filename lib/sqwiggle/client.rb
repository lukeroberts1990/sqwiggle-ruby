module Sqwiggle
  class Client
    class NoTokenError < StandardError;end;

    attr_accessor :token

    def initialize(token=nil)
      unless @token = token || Sqwiggle.token
        raise NoTokenError 
      end
    end

    def get(endpoint, params={})
      connection.get endpoint, params
    end

    private

    def url
      'localhost:3001'
    end

    def connection
      @connection ||= Faraday.new(url:url) do |f|
        f.request  :url_encoded             # form-encode POST params
        f.response :logger                  # log requests to STDOUT
        f.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        f.basic_auth token, 'X'
      end
    end

  end
end
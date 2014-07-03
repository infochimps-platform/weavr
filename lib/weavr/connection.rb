module Weavr
  class Connection

    attr_reader :connection

    def initialize
      @connection = Faraday.new(url: 'http://localhost:8080/api/v1') do |conn|
        conn.request  :json
        conn.request  :basic_auth, 'admin', 'admin'
        conn.response :json
        conn.adapter  Faraday.default_adapter
      end
    end
  end
end


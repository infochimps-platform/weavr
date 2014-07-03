module Weavr
  class Connection

    attr_reader :connection, :host, :port

    def initialize(options = {})
      options = Weavr.default_configuration.merge(options)
      @host = options[:host]
      @port = options[:port]
      configure_connection(options[:username], options[:password])
    end

    def configure_connection(user, password)
      @connection ||= Faraday.new(url: base_url, headers: request_headers) do |conn|
        conn.request  :json
        conn.request  :basic_auth, user, password
        conn.response :json
        conn.adapter  Faraday.default_adapter
      end
    end

    def base_url
      "http://#{host}:#{port}/api/v1"
    end

    def request_headers
      { 'X-Requested-By' => "Weavr #{Weavr::VERSION}" }
    end

    def resource(action, path)
      connection.send(action, path)
      # Response.new(resp.status, resp.headers, resp.body)
    end

    def clusters
      Collection.of(Cluster).receive resource(:get, 'clusters').body
    end

    def cluster name
      Cluster.receive resource(:get, "clusters/#{name}").body
    end
  end
end

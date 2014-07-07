module Weavr
  class Connection

    attr_reader :connection, :host, :port

    def initialize(options = {})
      options = Weavr.default_configuration.merge(options)
      @host   = options[:host]
      @port   = options[:port]
      configure_connection(options[:username], options[:password])
    end

    def configure_connection(user, password)
      @connection ||= Faraday.new(url: base_url, headers: request_headers) do |conn|
        conn.request  :basic_auth, user, password
        conn.response :json
        conn.response :logger, Weavr.logger
        conn.adapter  Faraday.default_adapter
      end
    end

    def base_url
      "http://#{host}:#{port}/api/v1"
    end

    def request_headers
      { 'X-Requested-By' => "Weavr v#{Weavr::VERSION}" }
    end

    def resource(action, path, data = {})
      resp = connection.send(action, path) do |req|
        req.body = data.to_json
      end
      Response.handle(resp.status, resp.headers, resp.body)
    rescue Faraday::ConnectionFailed
      raise ConnectionError.new "Could not reach Ambari API at #{host}:#{port}"
    end

    def clusters
      Collection.of(Cluster).receive resource(:get, 'clusters')
    end

    def cluster name
      Cluster.receive resource(:get, "clusters/#{name}")
    end

    def create_cluster name
      cluster = Cluster.receive(cluster_name: name, href: File.join(base_url, 'clusters', name))
      cluster.create
    end
  end
end

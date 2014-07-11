module Weavr
  class Connection

    attr_reader :host, :port, :http

    def initialize(options = {})
      @host = options[:host]
      @port = options[:port]
      establish_connection(options[:username], options[:password])
    end

    def establish_connection(user, password)
      @http ||= Faraday.new(url: base_url, headers: request_headers) do |conn|
        conn.request  :basic_auth, user, password
        conn.response :json
        conn.response :logger, Weavr.log
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
      resp = http.send(action, path) do |req|
        Weavr.log.info "payload: #{data}" if data
        req.body = data.to_json if data
      end
      Weavr.log.info "body: #{resp.body}"
      Response.handle(resp.status, resp.headers, resp.body)
    rescue Faraday::ConnectionFailed
      raise ConnectionError.new "Could not reach Ambari API at #{host}:#{port}"
    end
  end
end

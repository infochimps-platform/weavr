module Weavr
  class Response

    attr_reader :body, :headers, :status

    def initialize(status, headers, body)
      @status  = status
      @headers = headers
      @body    = body
    end

    def error_message
      body['message']
    end

  end
end

module Weavr
  class Response
    include Gorillib::Model

    field :status,  Integer
    field :headers, Hash
    field :body,    Hash
    field :errors,  Array, default: []

    def self.handle(status, headers, body)
      self.receive(status: status, headers: headers, body: body).validate!
    end

    # Really wish there was validations for these
    def receive_status param
      case param
      when 200
        @status = param
      when 400
        errors << { status: 400 }
      when 404
        errors << { status: 404 }
      when 500
        errors << { status: 500 }
      end
    end

    # def receive_headers param
    # end

    # def receive_body param
    # end

    def validate!
      raise RequestError.new error_message unless errors.empty?
      body
    end

    def error_message
      body['message']
    end

  end
end

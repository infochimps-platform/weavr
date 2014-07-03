require 'faraday'
require 'faraday_middleware'

require 'weavr/connection'
require 'weavr/resource'
require 'weavr/response'
require 'weavr/version'

module Weavr

  DEFAULT_USERNAME = 'admin'
  DEFAULT_PASSWORD = 'admin'
  AMBARI_HOST      = 'localhost'
  AMBARI_PORT      = 8080

  def self.default_configuration
    {
      username: DEFAULT_USERNAME,
      password: DEFAULT_PASSWORD,
      host:     AMBARI_HOST,
      port:     AMBARI_PORT,
    }
  end

  def self.connection
    @connection ||= Connection.new
  end
end

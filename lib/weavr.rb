require 'faraday'
require 'faraday_middleware'
require 'gorillib/model'
require 'gorillib/string/inflections'
require 'gorillib/type/extended'

require 'weavr/connection'
require 'weavr/error'
require 'weavr/resource'
require 'weavr/resource/class_map'
require 'weavr/resource/cluster'
require 'weavr/resource/collection'
require 'weavr/resource/component'
require 'weavr/resource/configuration'
require 'weavr/resource/host'
require 'weavr/resource/host_role'
require 'weavr/resource/request'
require 'weavr/resource/service'
require 'weavr/resource/task'
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

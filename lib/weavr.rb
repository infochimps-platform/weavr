require 'faraday'
require 'faraday_middleware'
require 'gorillib/model'
require 'gorillib/string/inflections'
require 'gorillib/type/extended'
require 'logger'

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

  def self.default_configuration
    {
      username:  'admin',
      password:  'admin',
      host:      'localhost',
      port:      8080,
      log_level: 'info',
    }
  end

  def self.connection
    @connection ||= Connection.new
  end

  def self.logger
    return @logger if @logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger.const_get default_configuration[:log_level].to_s.upcase
    @logger
  end
end

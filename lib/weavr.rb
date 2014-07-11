require 'active_support/core_ext/string/inflections'
require 'faraday'
require 'faraday_middleware'
require 'gorillib/builder'
require 'gorillib/model/type/extended'
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
  extend self

  def default_configuration
    {
      username:  'admin',
      password:  'admin',
      host:      'localhost',
      port:      8080,
      log_level: 'info',
      log_format: ->(sev, t, prog, msg){ "[%-5s] %s\n" % [sev.downcase, msg] }
    }
  end

  def default_logger(level, formatter)
    logger = Logger.new(STDOUT)
    logger.level = Logger.const_get(level.to_s.upcase)
    logger.formatter = formatter
    logger
  end

  def configure(overrides = {})
    options = default_configuration.merge(overrides)
    set_log options[:logger] || default_logger(options[:log_level], options[:log_format])
    set_connection Connection.new(options)
  end

  def set_connection http
    @connection ||= http
  end

  def connection
    return @connection if @connection
    configure
  end

  def set_log device
    @log ||= device
  end

  def log
    @log
  end

  # Should probably be Cluster.find
  def cluster name
    Cluster.receive connection.resource(:get, "clusters/#{name}")
  end

  def clusters
    Collection.of(Cluster).receive connection.resource(:get, 'clusters')
  end

  # Should probably be Cluster.create
  def create_cluster name
    cluster = Cluster.receive(cluster_name: name, href: File.join(connection.base_url, 'clusters', name))
    cluster.create
  end
end

require 'configliere'

require_relative '../lib/weavr'

# config

Settings.use :commandline

Settings.define :ambari_cluster_name, default: 'hwx'
Settings.define :ambari_host, default: 'hdp-nn'
Settings.define :ambari_port, default: 8080, type: Integer
Settings.define :ambari_username, default: 'admin'
Settings.define :ambari_password, default: 'admin'
Settings.define :ambari_wait_sec, default: 5.0

Settings.resolve!

Weavr.configure(
  host: Settings.ambari_host,
  port: Settings.ambari_port,
  username: Settings.ambari_username,
  password: Settings.ambari_password,
)

# weavr cluster

w = Weavr.cluster(Settings.ambari_cluster_name)

# go!

Weavr::CLI.new(w).repl

# Weavr

A Ruby client for Apache Ambari [REST client](https://github.com/apache/ambari/blob/trunk/ambari-server/docs/api/v1/index.md)

## Installation

Add this line to your application's Gemfile:

    gem 'weavr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weavr

## Usage

Configure the singleton client:

```ruby
Weavr.configure(host:       'ambari.web.host',
		port:       8080,
                username:   'barnaby',
                password:   'jones',
                log_level:  'debug',
                log_format: ->(sev, t, prog, msg){ "%s - %s - %s\n", [t, sev, msg] })
```

Create a new cluster:

```ruby
hwx = Weavr.create_cluster 'hwx'
```

Retrieve an existing cluster:

```ruby
hwx = Weavr.cluster 'hwx'
```

Add hosts to the cluster. They must already exist and have Ambari agent properly configured:

```ruby
hwx.add_hosts('hadoop0', 'hadoop1', 'hadoop2')
```

Add services to the cluster:

```ruby
hwx.add_services('HDFS', 'YARN', 'ZOOKEEPER')
```

Add components to the services:

```ruby
hwx.add_components('HDFS', ['NAMENODE', 'DATANODE', 'HDFS_CLIENT'])
```

Assign components to hosts:

```ruby
hwx.assign_host_components('hadoop0' => ['NAMENODE'],
   		           'hadoop1' => ['DATANODE', 'HDFS_CLIENT'],
   			   'hadoop2' => ['DATANODE', 'HDFS_CLIENT'])
```

Create config files:

```ruby
hwx.create_config('hdfs-site', 'version2', 'some.java.prop' => 'value')
```

Persist the cluster for the web api:

```ruby
hwx.persist
```

Access collections of objects by name:

```ruby
hdfs = hwx.services['HDFS']
nn = hdfs.components['NAMENODE']
```

All objects can be refreshed to repopulate parameters:

```ruby
hwx.refresh!
hwx.services['HDFS'].refresh!
hwx.services['HDFS'].components['NAMENODE'].refresh!
```

Adjust the repositories used to install components:

```ruby
Weavr.configure_repository(version: '2.1', os: 'redhat6', repo: 'HDP-2.1', url: 'http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.1.3.0/')
```

### Blueprints

As of 1.6.0, Ambari supports blueprints, which are a convenient way to save
and reuse ambari hadoop cluster configurations.

For more info on blueprints, see [this blog post](http://hortonworks.com/blog/ambari-blueprints-delivers-missing-component-cluster-provisioning/) or [the ambari wiki](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).

Sample usage:

```ruby
service_blueprint_name = 'blueprint-hwx'
cluster_name = 'hwx'
service_blueprint_filename = 'hdp_blueprint_services.json'
cluster_blueprint_filename = 'hdp_blueprint_cluster.json'
create_request = Weavr.create_cluster_from_blueprint(
  service_blueprint_name,
  cluster_name,
  service_blueprint_filename,
  cluster_blueprint_filename
)

# wait for services to install and start
while create_request.id && create_request.progress_percent != 100.0
  sleep 5
  create_request.refresh!
end
```

### CLI

Weavr includes a simple CLI that can start, stop and reconfigure
services via the command-line.

#### Sample Usage

```
bundle exec ruby ./bin/weavr-cli.rb
pry(#Weavr::CLI))> stop 'HDFS'
pry(#Weavr::CLI))> wait 'INSTALLED', 'HDFS'
pry(#Weavr::CLI))> reconfigure {"hive.heapsize":"2000mb"}, '1', '2', 'global'
pry(#Weavr::CLI))> start 'HDFS'
pry(#Weavr::CLI))> wait 'STARTED', 'HDFS'
```

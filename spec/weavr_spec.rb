require 'spec_helper'

describe Weavr do

  def clear_variables mod
    mod.instance_variables.each do |ivar|
      mod.instance_variable_set(ivar, nil)
    end
  end

  subject(:weavr)              { described_class   }
  subject(:collection_resource){ Weavr::Collection }
  subject(:blueprint_resource) { Weavr::Blueprint  }
  subject(:cluster_resource)   { Weavr::Cluster    }
  subject(:request_resource)   { Weavr::Request    }

  # dummy json data for mock blueprints
  let(:data) {"{}"}

  after(:each) do
    clear_variables described_class
  end

  context '.configure' do
    it 'sets the log' do
      weavr.configure
      expect(weavr.log).to_not be_nil
    end

    it 'sets the connection' do
      weavr.configure
      expect(weavr.connection).to_not be_nil
    end

    it 'allows overrides' do
      weavr.configure(log_level: 'debug', host: 'foo')
      expect(weavr.log.level).to       eq(Logger::DEBUG)
      expect(weavr.connection.host).to eq('foo')
    end
  end

  context '.connection' do
    it 'returns the connection if set' do
      weavr.set_connection :conn
      expect(weavr.connection).to eq(:conn)
    end

    it 'configures a default connection if unset' do
      weavr.should_receive(:configure)
      weavr.connection
    end
  end

  context '.log' do
    it 'returns the log if set' do
      weavr.set_log :device
      expect(weavr.log).to eq(:device)
    end
  end

  context '.cluster' do
    it 'returns the named cluster' do
      weavr.connection.should_receive(:resource).with(:get, 'clusters/foo').and_return(cluster_name: 'foo')
      expect(weavr.cluster('foo').cluster_name).to eq('foo')
    end
  end

  context '.clusters' do
    it 'returns a collection of clusters' do
      weavr.connection.should_receive(:resource).with(:get, 'clusters').and_return(items: [{ cluster_name: 'foo' }])
      clusters = weavr.clusters
      expect(clusters).to be_a(collection_resource)
      expect(clusters.items.one?{ |c| c.cluster_name == 'foo' }).to be_true
    end
  end

  context '.create_cluster' do
    it 'creates a new cluster' do
      weavr.connection.should_receive(:resource).with(:post, 'clusters/foo', an_instance_of(Hash)).and_return(cluster_name: 'foo')
      cluster = weavr.create_cluster('foo')
      expect(cluster).to be_a(cluster_resource)
      expect(cluster.cluster_name).to eq('foo')
    end
  end

  context '.get_blueprints' do
    it 'gets all available blueprints' do
      weavr.connection.should_receive(:resource).with(:get, 'blueprints')
      blueprint = blueprint_resource.new(href: 'blueprints')
      blueprint.get_blueprints
    end

    it 'generates a blueprint from a cluster' do
      weavr.connection.should_receive(:resource).with(:get, 'clusters/foo?format=blueprint')
      cluster = cluster_resource.new
      cluster.get_blueprint 'foo'
    end
  end

  context '.create_cluster_from_blueprint' do
    it 'creates a new blueprint' do
      File.stub(:open).with('baz.json','r') { StringIO.new(data) }
      weavr.connection.should_receive(:resource).with(:post, 'blueprints/foo', an_instance_of(Hash))
      blueprint = blueprint_resource.new(blueprint_name: 'foo', href: 'blueprints/foo')
      blueprint.create 'baz.json'
    end

    it 'creates a new cluster from a blueprint' do
      File.stub(:open).with('baz.json','r') { StringIO.new(data) }
      weavr.connection.should_receive(:resource).with(:post, 'clusters/foo', an_instance_of(Hash))
      cluster = cluster_resource.new(cluster_name: 'foo', href: 'clusters/foo')
      req = cluster.create_from_blueprint 'baz.json'
      expect(cluster).to be_a(cluster_resource)
      expect(cluster.cluster_name).to eq('foo')
      expect(req).to be_a(request_resource)
    end
  end

  context '.stacks' do
    it 'returns a collection of stacks' do
      weavr.connection.should_receive(:resource).with(:get, 'stacks2').and_return(items: [{ stack_name: 'hdp' }])
      stacks = weavr.stacks
      expect(stacks).to be_a(collection_resource)
      expect(stacks.items.one?{ |c| c.stack_name == 'hdp' }).to be_true
    end
  end

  context '.hosts' do
    it 'returns a collection of hosts' do
      weavr.connection.should_receive(:resource).with(:get, 'hosts').and_return(items: [{ host_name: "host.name"}])
      hosts = weavr.hosts
      expect(hosts).to be_a(collection_resource)
      expect(hosts.items.one?{ |h| h.host_name == 'host.name' }).to be_true
    end
  end

  context '.configure_repository' do
  end
end

require 'spec_helper'

describe Weavr do

  def clear_variables mod
    mod.instance_variables.each do |ivar|
      mod.instance_variable_set(ivar, nil)
    end
  end

  subject(:weavr)              { described_class   }
  subject(:collection_resource){ Weavr::Collection }
  subject(:cluster_resource)   { Weavr::Cluster    }

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

  context '.stacks' do
    it 'returns a collection of stacks' do
      weavr.connection.should_receive(:resource).with(:get, 'stacks2').and_return(items: [{ stack_name: 'hdp' }])
      stacks = weavr.stacks
      expect(stacks).to be_a(collection_resource)
      expect(stacks.items.one?{ |c| c.stack_name == 'hdp' }).to be_true
    end
  end

  context '.configure_repository' do
  end
end

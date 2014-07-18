if ENV['WEAVR_COV']
  require 'simplecov'
  SimpleCov.start do
    add_group 'Specs',   'spec/'
    add_group 'Library', 'lib/'
  end
end

require 'weavr'

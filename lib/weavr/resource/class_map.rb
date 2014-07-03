# Declare all classes ahead of time to avoid dependency problems
module Weavr
  Cluster       = Class.new Resource
  Collection    = Class.new Resource
  Component     = Class.new Resource
  Configuration = Class.new Resource
  Host          = Class.new Resource
  HostRole      = Class.new Resource
  Request       = Class.new Resource
  Service       = Class.new Resource
  Task          = Class.new Resource
end



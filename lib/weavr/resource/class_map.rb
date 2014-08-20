# Declare all classes ahead of time to avoid dependency problems
%w[ Blueprint Cluster Collection Component Configuration Host
    HostRole OperatingSystem Repository Request
    Service ServiceComponent  Stack StackConfiguration
    StackService StackVersion Task
].each{ |resource| Weavr::Resource.predefine_class resource }

Weavr::Resource.load_definitions!



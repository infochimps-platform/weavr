module Weavr
  class Host < Resource
    field :cluster_name,           String
    field :host_name,              String
    field :cpu_count,              Integer
    field :disk_info,              Array, of: Hash # Fix me
    field :host_health_report,     String
    field :host_status,            String
    field :ip,                     IpAddress
    field :last_agent_env,         Hash            # Fix me
    field :last_heartbeat_time,    Integer         # Needs to be date
    field :last_registration_time, Integer         # Needs to be date
    field :maintenance_state,      String
    field :os_arch,                String
    field :os_type,                String
    field :ph_cpu_count,           Integer
    field :public_host_name,       String
    field :rack_info,              String
    field :total_mem,              Integer
    field :desired_configs,        Hash            # Fix me
    field :host_components,        Array, of: HostRole
  end
end

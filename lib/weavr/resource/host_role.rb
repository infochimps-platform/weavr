module Weavr
  class HostRole < Resource
    field :cluster_name,        String
    field :component_name,      String
    field :host_name,           String
    field :desired_admin_state, String
    field :desired_stack_id,    String
    field :desired_state,       String
    field :maintenance_state,   String
    field :stack_id,            String
    field :stale_configs,       :boolean
    field :state,               String
    field :actual_configs,      Hash   # Fix
    field :host,                Hash   # Fix
    field :metrics,             Hash   # Fix
    field :processes,           Array  # Fix
    field :component,           Array, of: Component
  end
end

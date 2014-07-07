module Weavr
  class Task < Resource
    field :cluster_name,   String
    field :attempt_cnt,    Integer
    field :id,             Integer
    field :request_id,     Integer
    field :command,        String
    field :command_detail, String
    field :exit_code,      Integer
    field :host_name,      String
    field :request_id,     String
    field :role,           String
    field :stage_id,       String
    field :start_time,     Integer # Needs to be Date
    field :status,         String
    field :stdout,         String
    field :structured_out, String
  end
end

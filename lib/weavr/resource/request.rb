module Weavr
  class Request < Resource
    field :cluster_name,         String
    field :id,                   Integer
    field :aborted_task_count,   Integer
    field :completed_task_count, Integer
    field :create_time,          Integer  # Needs to be Date
    field :end_time,             Integer  # Needs to be Date
    field :failed_task_count,    Integer
    field :inputs,               Whatever # Fix
    field :progress_percent,     Float
    field :queued_task_count,    Integer
    field :request_context,      String
    field :request_schedule,     Whatever # Fix
    field :request_status,       String
    field :resource_filter,      Array
    field :start_time,           Integer  # Needs to be Date
    field :task_count,           Integer
    field :timed_out_task_count, Integer
    field :type,                 String
    field :tasks,                Array, of: Task
  end
end

#
# Define queue
#
class ApplicationJob < ActiveJob::Base
  # Example of specified sidekiq queue namespace
  # See config/environments/production for more options
   queue_as Hyrax.config.ingest_queue_name
end

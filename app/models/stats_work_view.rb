class StatsWorkView < ApplicationRecord
  # check to see if we have recorded any stats for this ip and work_id 
  # the last 8 hours
  scope :check_active, ->(ip_address, work_id) { where("created_at::time >= (current_time - interval '8' hour)  AND ip_address = ? AND  work_id = ?", ip_address, work_id) }
end

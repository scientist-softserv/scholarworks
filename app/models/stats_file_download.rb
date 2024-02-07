class StatsFileDownload < ApplicationRecord
  # check to see if we have recorded any stats for this ip and file_id
  # the last 8 hours
  scope :check_active, ->(ip_address, file_id) { where("created_at::time >= (current_time - interval '8' hour)  AND ip_address = ? AND  file_id = ?", ip_address, file_id) }
end

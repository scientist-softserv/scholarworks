class AddAwsLoctionAndJobIdToGlacierDownloadRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :glacier_sns_download_requests, :aws_job_identifier, :string
    add_column :glacier_sns_download_requests, :aws_location, :text
  end
end

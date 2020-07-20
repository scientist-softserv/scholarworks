class UpdateGlacierDownloadRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :glacier_sns_download_requests, :aws_job_identifier, :string
    remove_column :glacier_sns_download_requests, :aws_location, :string
    rename_column :glacier_sns_download_requests, :glacier_identifier, :s3_key
  end
end

require 'securerandom'

#  Upload file to aws Glacier
#
class GlacierUploadService < ActiveJob::Base
  # @param [ActiveFedora::FileSet] the file set containing file to be uploaded
  #
  def self.upload(file_set)
    return true unless validated?(file_set)
    file = file_set.original_file

    resp = client.upload_archive({
      account_id: "-",
      archive_description: timestamp(file_set),
      body: file.content,
      vault_name: vault
    })
    file_set.update(glacier_location: file_set.glacier_location + ["#{timestamp(file_set)}::#{resp.archive_id}"])
  rescue
    return false
  end

  def self.download(download_request)
    archive_id = download_request.glacier_identifier
    client.initiate_job({
      account_id: "-",
      vault_name: vault,
      job_parameters: {
        archive_id: archive_id,
        description: "Glacier fetch for #{download_request.user.email}, initiated at #{Time.now.to_s(:db)}"
      },
      output_location: {
        s3:{
          bucket_name: bucket_name,
          canned_acl: access_level
        }
      }
    })
  end

  private
  def self.client
    Aws::Glacier::Client.new
  end

  def self.bucket_name
    ENV['GLACIER_UNARCHIVE_S3_BUCKET']
  end

  def self.access_level
    ENV['GLACIER_UNARCHIVE_S3_ACCESS']
  end

  def self.vault
    ENV['AWS_GLACIER_VAULT']
  end

  def self.timestamp(file_set)
    file_set.original_file.create_date.to_s(:db)
  end

  def self.validated? file_set
    original_file = file_set.original_file
    return false if original_file.nil?

    timestamps = file_set.glacier_location.map{|l| l.split("::")[0]}
    modified = timestamp(file_set)

    !timestamps.include?(modified)
  end
end

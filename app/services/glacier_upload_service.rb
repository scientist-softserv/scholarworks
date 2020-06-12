require 'securerandom'

#  Upload file to aws Glacier
#
class GlacierUploadService < ActiveJob::Base
  # @param [ActiveFedora::FileSet] the file set containing file to be uploaded
  #
  def self.upload(file_set)
    return true unless validated?(file_set)
    file = file_set.original_file
    s3_key = key(file_set)

    resp = client.put_object({
      body: file.content,
      bucket: bucket_name,
      key: s3_key,
      storage_class: "GLACIER"
    })

    file_set.update(glacier_location: file_set.glacier_location + [s3_key])
  rescue
    return false
  end

  def self.download(s3_key)
    resp = client.restore_object({
      bucket: bucket_name,
      key: s3_key,
      restore_request:{
        days: 7,
        glacier_job_parameters: {
          tier: "Standard", # required, accepts Standard, Bulk, Expedited
        },
      }
    })
  end

  private
  def self.client
    Aws::S3::Client.new
  end

  def self.bucket_name
    ENV['GLACIER_S3_BUCKET']
  end

  def self.key file_set
    file_set.original_file.id
  end

  def self.validated? file_set
    original_file = file_set.original_file
    return false if original_file.nil?
    return false if file_set.glacier_location.include? key(file_set)
    return true
  end
end

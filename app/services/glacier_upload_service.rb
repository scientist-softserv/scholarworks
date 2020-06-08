require 'securerandom'

#  Upload file to aws Glacier
#
class GlacierUploadService < ActiveJob::Base
  # @param [ActiveFedora::FileSet] the file set containing file to be uploaded
  #
  def self.upload(file_set)
    return true unless validated?(file_set)
    file = file_set.original_file

    client = Aws::Glacier::Client.new(
      region: ENV['AWS_REGION']
    )
    vault = ENV['AWS_GLACIER_VAULT']
    client = Aws::Glacier::Client.new

    resp = client.upload_archive({
      account_id: "-",
      archive_description: timestamp,
      body: file.content,
      vault_name: vault
    })
    file_set.update(glacier_location: file_set.glacier_location + ["#{timestamp}::#{resp.archive_id}"])
  rescue
    return false
  end

  private
  def self.timestamp
    Time.now.strftime("%Y%m%dT%H%M%S%z")
  end

  def self.validated? file_set
    !file_set.original_file.nil?
  end
end

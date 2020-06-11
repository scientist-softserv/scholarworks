class GlacierSnsDownloadRequest < ApplicationRecord
  belongs_to :user
  validates :user, :glacier_identifier, presence: true

  after_create :make_request

  def make_request 
    response = GlacierUploadService.download(self)
    if response.job_id
      update_attributes(aws_job_identifier: response.job_id, aws_location: response.location)
    end
  end
end

class GlacierSnsDownloadRequest < ApplicationRecord
  belongs_to :user
  validates :user, :glacier_identifier, presence: true

  after_create :make_request
  before_save :email_link

  def make_request 
    response = GlacierUploadService.download(self)
    if response.job_id
      update_attributes(aws_job_identifier: response.job_id, aws_location: response.location)
    end
  end

  def email_link
    if self.is_complete_changed? and self.is_complete?
      GlacierMailer.unarchive_complete_email(self.user, self.aws_location).deliver_later
    end
  end
end

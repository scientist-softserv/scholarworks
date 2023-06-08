#
# AWS Glacier download call
#
class GlacierSnsDownloadRequest < ApplicationRecord
  belongs_to :user
  validates :user, :s3_key, presence: true

  after_create :make_request
  before_save :email_link

  def make_request 
    GlacierUploadService.download(self.s3_key)
  end

  def email_link
    if self.is_complete_changed? and self.is_complete?
      GlacierMailer.unarchive_complete_email(self.user, self.s3_key).deliver_later
    end
  end
end

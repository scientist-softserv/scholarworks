class GlacierSnsDownloadRequest < ApplicationRecord
  belongs_to :user
  validates :user, :glacier_identifier, presence: true
end

class GlacierSnsDownloadRequest < ApplicationRecord
  belongs_to :user
  validates :user, :glacier_location, presence: true
end

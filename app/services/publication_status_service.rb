# frozen_string_literal: true

#
# Publication status authority
#
class PublicationStatusService < AuthorityService
  def initialize(controller)
    super('publication_status', controller)
  end
end

# frozen_string_literal: true

#
# Register work with Handle service
#
class HandleService < ActiveJob::Base
  require 'handle_system'

  #
  # Register with Handle service
  #
  # @param resource [ActiveFedora::Base]  work
  #
  def self.register(resource)
    # no access key (probably we are on dev or test) so skip
    unless File.exist?(Rails.root.join('admpriv.pem'))
      logger.warn 'No admpriv.pem file, so skipping Handle registration.'
      return
    end

    hyrax_path = Rails.application.routes.url_helpers.polymorphic_path(resource, host: ENV['SCHOLARWORKS_HOST'])

    handle_server = ENV['HANDLE_SERVER']
    hs_admin = ENV['HS_ADMIN']
    private_key = ENV['HS_PRIVATE_KEY']

    handle_client = HandleSystem::Client.new(handle_server, hs_admin, private_key)

    prefix = ENV['HS_PREFIX']
    suffix = resource.id
    handle = prefix + '/' + suffix

    logger.info "Registering #{suffix} to Handle"
    handle_url = handle_client.create(handle, hyrax_path)
    resource.handle = [handle_url]
    resource.save!
  end
end

# get handle id
#

class HandleService < ActiveJob::Base
  require 'handle_system'

  # @param [env]
  #
  def self.register(resource)
    handle_server = ENV['HANDLE_SERVER']
    hs_admin = ENV['HS_ADMIN']
    private_key = ENV['HS_PRIVATE_KEY']

    handle_client = HandleSystem::Client.new(handle_server, hs_admin, private_key)

    # TODO: check with them what the prefix and suffix should be
    prefix = ENV['HS_PREFIX']
    suffix = ENV['HS_SUFFIX']
    handle = prefix + '/' + suffix

    #TODO: find how to retrive this from the work
    hyrax_url = Rails.application.routes.url_helpers.hyrax_thesis_path(resource)

    logger.info "Registering #{suffix} to Handle"
    handle_url = handle_client.create(handle, hyrax_url)
    resource.handle = handle_url
    resource.save!
  end
end
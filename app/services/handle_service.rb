# get handle id
#

class HandleService < ActiveJob::Base
  require 'handle_system'

  # @param [env]
  #
  def self.register(resource, hyrax_path)
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
# frozen_string_literal: true

require_relative 'packager/dspace'
require_relative 'packager/islandora'
require_relative 'packager/log'
require_relative 'packager/proquest'
require_relative 'packager/zenodo'


module CalState
  #
  # Migration classes and methods
  #
  module Packager
    #
    # Add the manager group to the work
    #
    # @param work [ActiveRecord::Base]  Fedora record
    # @param campus [String]            campus slug
    #
    # @return [ActiveRecord::Base]
    #
    def self.add_manager_group(work, campus)
      group = 'managers-' + campus
      work.edit_groups = [group]
      work
    end

    #
    # Add individual managers to the work
    #
    # @param work [ActiveRecord::Base]  Fedora record
    # @param admin_set_id [String]      admin set identifier
    #
    # @return [ActiveRecord::Base]
    #
    def self.add_managers(work, admin_set_id)
      permission = Hyrax::PermissionTemplate.find_by!(source_id: admin_set_id)
      return work if permission.nil?

      managers = permission.agent_ids_for(agent_type: 'user', access: 'manage')
      return work if managers.nil?

      work.edit_users = managers
      work.edit_users = work.edit_users.dup
      work
    end
  end
end

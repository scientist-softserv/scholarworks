#
# Assign campus for a work
#
module Hyrax
  module Actors
    #
    # Assigns campus for a work based on the name of the admin_set to which it belongs
    #
    # Will only assign campus if it is not already set
    #
    class AssignCampusActor < Hyrax::Actors::AbstractActor

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        assigned = if env.curation_concern.campus.blank?
                     admin_set_id = env.attributes[:admin_set_id]
                     admin_set_title = AdminSet.find(admin_set_id).title.first
                     env.curation_concern.assign_campus(admin_set_title)
                   else
                     true
                   end
        assigned && next_actor.create(env)
      end
    end
  end
end

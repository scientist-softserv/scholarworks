module Hyrax
  module Actors
    class HandleActor < Hyrax::Actors::AbstractActor
      def create(env)
        update_handle(env) && next_actor.create(env)
      end

      def update(env)
        update_handle(env) && next_actor.update(env)
      end

      private

      def update_handle(env)
        reource = env.curatioon_concern
        return resource.handle if resource.handle.present?

        HandleRegisterJob.perform_later(resource)
      end
    end
  end
end
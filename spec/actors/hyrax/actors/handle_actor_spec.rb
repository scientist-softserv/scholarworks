# Generated via
#  `rails generate hyrax:work NtlWork`
require 'rails_helper'

RSpec.describe Hyrax::Actors::HandleActor, clean: true do
  subject(:actor) { described_class.new(terminator) }
  let(:ability) { ::Ability.new(depositor) }
  let(:attributes) { HashWithIndifferentAccess.new }
  let(:depositor) { build(:user) }
  let(:env) { Hyrax::Actors::Environment.new(work, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:work) { FactoryBot.create(:thesis, admin_set: AdminSet.create(title: ["San Marcos"])) }

  describe '#create' do
    before do
      ActiveJob::Base.queue_adapter = :test
    end
    it 'enqueues a job' do
      expect { actor.create(env) }
          .to have_enqueued_job(HandleRegisterJob)
                  .with(work)
    end
  end
end
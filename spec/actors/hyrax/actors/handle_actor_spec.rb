# Generated via
#  `rails generate hyrax:work NtlWork`
require 'rails_helper'

RSpec.describe Hyrax::Actors::HandleActor do
  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  let(:ability) { ::Ability.new(depositor) }
  let(:attributes) { HashWithIndifferentAccess.new }
  let(:depositor) { create(:user) }
  let(:env) { Hyrax::Actors::Environment.new(work, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:work) { create(:thesis) }

  describe '#create' do
    it 'populates a handle' do
      expect(subject.create(env)).to be true
      expect(work.handle).not_to be_nil
    end
  end
end
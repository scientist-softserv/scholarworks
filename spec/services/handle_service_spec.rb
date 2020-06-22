require 'rails_helper'

RSpec.describe HandleService do
  describe '#register' do
    let(:resource) { build(:thesis, id: 'testid', admin_set: AdminSet.create(title: ["San Marcos"])) }
    let(:hyrax_path) { 'thesis/testpath' }
    describe 'happy path' do
      let(:handle_double) { double('HandleSystem', create: 'handle_url')}
      before do
        HandleSystem::Client.stub(:new) { handle_double }
      end

      it 'should call the handle service' do
        HandleService.register(resource, hyrax_path)
        expect(resource.handle).to eq(['handle_url'])
      end
    end

    describe 'if you use the wrong prefix' do
      it 'raises an error' do
        allow_any_instance_of(HandleSystem::Client).to receive(:create).with(anything(), anything()).and_raise("That prefix doesn't live here")
        # Note: the expected error is actually HandleSystem::Error.new, "That prefix doesn't live here"

        expect{HandleService.register(resource, hyrax_path)}.to raise_error
      end
    end

    describe 'if the handle service is unauthenticated' do
      before do
        expect(HandleSystem::Client).to receive(:new).and_raise(HandleSystem::AuthenticationError, "Identity not verified")
      end

      it 'raises an error' do
        expect{HandleService.register(resource, hyrax_path)}.to raise_error(HandleSystem::AuthenticationError, "Identity not verified")
      end
    end

  end
end
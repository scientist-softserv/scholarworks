require 'rails_helper'

RSpec.describe HandleService do
  describe '#register' do
    let(:resource) { build(:thesis, id: 'testid', admin_set: AdminSet.create(title: ["San Marcos"])) }
    let(:hyrax_path) { 'thesis/testpath' }
    let(:handle_double) { double('HandleSystem', create: 'handle_url')}

    before do
      HandleSystem::Client.stub(:new) { handle_double }
    end

    it 'should call the handle service' do
      HandleService.register(resource, hyrax_path)
      expect(resource.handle).to eq(['handle_url'])
    end

    describe 'if the handle service returns an error' do
      before do
        expect(handle_double).to receive(:create).and_raise(StandardError.new("api error"))
      end

      it 'raises an error' do
        expect{HandleService.register(resource, hyrax_path)}.to raise_error(ArgumentError, "Handle API encountered an error")
      end
    end
  end
end
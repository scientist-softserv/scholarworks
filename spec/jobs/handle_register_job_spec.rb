require 'rails_helper'

RSpec.describe HandleRegisterJob, type: :job do

  describe '#create' do
    describe 'happy path' do
      let(:resource) { create(:thesis, handle: nil, admin_set: AdminSet.create(title: ["San Marcos"])) }
      it 'calls the handle service' do
        expect(HandleService).to receive(:register).with(anything(), anything()).and_return(true)
        expect(HandleRegisterJob.perform_now(resource))
      end
    end

    describe 'when it already has a handle' do
      let(:resource) { build(:thesis, handle: ['handle']) }

      it 'does not call the handle service' do
        expect(resource.handle).to eq(['handle'])
        expect(HandleService).not_to receive(:register)
        expect(HandleRegisterJob.perform_now(resource)).to eq(true)
      end
    end
  end
end
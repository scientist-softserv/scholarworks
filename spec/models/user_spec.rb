require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:another_user) { build(:user) }

  describe 'verifying factories' do
    describe ':user' do
      let(:user) { build(:user) }

      xit 'will, by default, have no groups' do
        expect(user.groups).to eq([])
        user.save!
        # Ensuring that we can refind it and have the correct groups
        expect(user.class.find(user.id).groups).to eq([])
      end
      xit 'will allow for override of groups' do
        user = build(:user, groups: 'chicken')
        expect(user.groups).to eq(['chicken'])
        user.save!
        # Ensuring that we can refind it and have the correct groups
        expect(user.class.find(user.id).groups).to eq(['chicken'])
      end
    end
    describe ':admin' do
      let(:admin_user) { create(:admin) }

      it 'will have an "admin" group' do
        expect(admin_user.groups).to eq(['admin'])
      end
      context 'when found from the database' do
        xit 'will have the expected "admin" group' do
          refound_admin_user = described_class.find(admin_user.id)
          expect(refound_admin_user.groups).to eq(['admin'])
        end
      end
    end
  end

  describe '#user_key' do
    xit 'is uid in prod' do
      expect(user.user_key).to eq user.uid
    end

    context 'with a custom user_key_field' do
      let(:user)  { build(:user, display_name: value, uid: value2) }
      let(:value) { 'moomin' }
      let(:value2) { '1234' }

      before do
        allow(Hydra.config).to receive(:user_key_field).and_return(:display_name)
      end

      xit 'is uid in prod' do
        expect(user.user_key).to eq value2
      end

      it 'is findable by user_key' do
        user.save

        expect(User.find_by_user_key(value)).to eq user
      end
    end
  end

  it 'has an email' do
    expect(user.email).to be_kind_of String
  end

  describe 'omniauthable user' do
    it 'has a uid field' do
      expect(user.uid).to be_kind_of String
    end
  end

  context 'shibboleth integration' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        uid: 'janeq',
        info: {
          first: 'Jane',
          last: 'Quest',
          display_name: 'Jane Quest',
          email: 'janeq@example.com',
          affiliation: 'student',
          campus: 'CSU'
        }
      )
    end
    let(:user) { described_class.from_omniauth(auth_hash) }

    before do
      described_class.delete_all
    end

    context 'shibboleth' do
      xit 'has a shibboleth provided name' do
        expect(user.display_name).to eq auth_hash.info.display_name
        expect(user.display_name).not_to eq nil
      end
      xit 'has a shibboleth provided uid which is not nil' do
        expect(user.uid).to eq auth_hash.uid
        expect(user.uid).not_to eq nil
      end
      xit 'has a shibboleth provided email which is not nil' do
        expect(user.email).to eq auth_hash.info.email
        expect(user.email).not_to eq nil
      end
      xit 'has a shibboleth provided affiliation' do
        expect(user.affiliation).to eq auth_hash.info.affiliation
        expect(user.affiliation).not_to eq nil
      end
      xit 'has a shibboleth provided campus' do
        expect(user.campus).to eq auth_hash.info.campus
        expect(user.campus).not_to eq nil
      end
    end

    context "in a world without passwords" do
      before do
        described_class.delete_all
      end

      xit "system users are created without error" do
        u = ::User.find_or_create_system_user("batch_user")
        expect(u).to be_instance_of(::User)
      end
    end
  end
end

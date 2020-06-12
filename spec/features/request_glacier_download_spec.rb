# Generated via
#  `rails generate hyrax:work Thesis`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'submit a download request', type: :request do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    let(:s3_service_mock) do
      double("AWS::S3::Client", restore_object: {})      
    end

    before do
      login_as user
      GlacierUploadService.stub(:client){ s3_service_mock }
    end

    it "should return 201" do
      post glacier_sns_download_requests_path, params: {s3_key: "abc123"}
      expect(response.status).to eq(201)
    end

    it "should require glacier_identifier" do
      post glacier_sns_download_requests_path
      expect(response.status).to eq(422)
    end

  end
end

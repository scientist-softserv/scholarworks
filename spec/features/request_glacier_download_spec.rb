# Generated via
#  `rails generate hyrax:work Thesis`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'submit a download request', type: :request do
  let(:user_attributes) do
    { email: 'test@example.com' }
  end
  let(:user) do
    User.new(user_attributes) { |u| u.save(validate: false) }
  end

  context 'a logged in user' do
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

  context "unarchive complete sns" do
    let(:s3_key){ "work/p2676v52c/h702q636h/files/2df6bec7-2068-432c-85d4-420b5a8c8094" }

    let!(:download_request) do
      GlacierSnsDownloadRequest.skip_callback(:create, :after,  :make_request)
      GlacierSnsDownloadRequest.create(user: user, s3_key: s3_key)
    end

    let(:sns_payload){
      {
        "Type"=>"Notification",
        "MessageId"=>"5551ba40-37b3-5eee-a315-ed219813437d",
        "TopicArn"=>
         "arn:aws:sns:us-west-2:559021623471:unarchive-cal-state-glacier-arhives",
        "Subject"=>"Amazon S3 Notification",
        "Message"=>
	  {"Records"=>
	    [{"eventVersion"=>"2.1",
	      "eventSource"=>"aws:s3",
	      "awsRegion"=>"us-west-2",
	      "eventTime"=>"2020-06-15T17:18:22.893Z",
	      "eventName"=>"ObjectRestore:Post",
	      "userIdentity"=>{"principalId"=>"AWS:AIDAINEZZFVZUJ3TGJ4OY"},
	      "requestParameters"=>{"sourceIPAddress"=>"76.167.198.108"},
	      "responseElements"=>
	       {"x-amz-request-id"=>"127110528EE72F5D",
		"x-amz-id-2"=>
		 "t9+ohO57KdkW9GxSFcPy+yPSuEbfk4XsBd7zsEFbZvFqtAU2EAXJJwIMt6eRctwcdjVEhI++WIhIbR5dBc4OVhG4Wfhgf9Nn"},
	      "s3"=>
	       {"s3SchemaVersion"=>"1.0",
		"configurationId"=>"YjNmZjk1ZjMtZDQyMS00NWQzLWExYTgtMzdjMGJkMjIzM2Q1",
		"bucket"=>
		 {"name"=>"cal-state-glacier-retrieval",
		  "ownerIdentity"=>{"principalId"=>"A7X23405V14VD"},
		  "arn"=>"arn:aws:s3:::cal-state-glacier-retrieval"},
		"object"=>
		 {"key"=> s3_key,
		  "size"=>3213037,
		  "eTag"=>"4ef3e29cefe19df91e3da554f526d27b",
		  "sequencer"=>"005EE7ACD705B47391"}}}]},
        "Timestamp"=>"2020-06-15T17:18:24.828Z",
        "SignatureVersion"=>"1",
        "Signature"=>
         "bo2JkNgNMWW7Z5vDxlgwCD7aZ6VgKpfa2keZv2HNAZ8iW9TG7CR2ICYoJpGZ+oTmZzOh3nPOtT3pLVWrNWUEFKJnB+id+atzJAgMSSJ4oTirWtbJ9of6CACUayK5x0ggSAAWJPK2M8Btxzp/rXVUP+iaZC+yXzFbo34z64KxJxxrwGwhJRzK/EFx4Nf9zG2aqyEoLQrTT/ijRGisu1i0Q7ERhV+02icOdbLk1PpNhIJF46FCLkBdDC/5HUQjvDN8AeiYoc/SvY0qQCEMz6QMhSt2D0gNnNtIIU2/pIpHz2VBnIkbwHHD4RnBH4FR2N1/qYcmvqaGPNTu6Qzd69WsdQ==",
        "SigningCertURL"=>
         "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-a86cb10b4e1f29c941702d737128f7b6.pem",
        "UnsubscribeURL"=>
         "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:559021623471:unarchive-cal-state-glacier-arhives:13f22c6e-d54d-4191-89c0-5b1886bc4417"
      }
    }



    it "should respond with a 200" do
      post unarchive_complete_sns_glacier_sns_download_requests_path params: sns_payload
      expect(response.status).to eq(200)
    end
  end
       


end
